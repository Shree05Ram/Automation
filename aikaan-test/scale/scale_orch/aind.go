package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
	"golang.org/x/net/context"
	"log"
	"math/rand"
	"net"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

const (
	DOCKER_CLIENT_VERSION = "1.35"
	DOCKER_IMAGE_NAME     = "aikaan/aind:latest"
	CONFIG_FILE           = "aiscale.json"
	DOCKER_CREATION_INTERVAL_OFFSET = 20
	CONTAINER_PREFIX      = "aiscale"
	MAX_HOSTS             = 1024
	AGENT_CONFIG_FILE     = "/opt/aikaan/etc/aiagent_config.json"
	DOCKER_INTERFACE      = "docker0"
)

type MyNet struct {
	IP           *net.IPNet
	Subnet       net.IP
	AvailableIPs []net.IP
}

func dockerStartAiagent(brmac string, brip string, container_name string) error {
	ctx := context.Background()
	cli, err := client.NewClientWithOpts(client.WithVersion(DOCKER_CLIENT_VERSION))
	if err != nil {
		log.Printf("ERR:Unable to create new docker client : %s", err)
		return err
	}
	var envlist []string
	var net_mode container.NetworkMode
	net_mode = ""
	resp, err := cli.ContainerCreate(ctx, &container.Config{
		Image: DOCKER_IMAGE_NAME,
		Env:   envlist,
	}, &container.HostConfig{
		Privileged:  true,
		NetworkMode: net_mode,
	}, nil, container_name)
	if err != nil {
		log.Printf("ERR:Unable to create aiagent container : %s", err)
		return err
	}

	if err := cli.ContainerStart(ctx, resp.ID, types.ContainerStartOptions{}); err != nil {
		log.Printf("ERR:Unable to start aiagent container : %s", err)
		return err
	}
	data, err := cli.ContainerInspect(ctx, resp.ID)
	if err != nil {
		log.Println(err)
		return err
	}
	dockerMAC := data.NetworkSettings.MacAddress
	dockerIP := data.NetworkSettings.IPAddress
	var cmdlist []string
	/*Install ARP entry inside docker*/
	arpCmd := fmt.Sprintf("%s %s %s %s", "arp", "-s", brip, brmac)
	cmdlist = nil
	cmdlist = append(cmdlist, "sh")
	cmdlist = append(cmdlist, "-c")
	cmdlist = append(cmdlist, arpCmd)
	err = runCommandOnContainer(ctx, cli, resp.ID, cmdlist)
	if err != nil {
		log.Println("ERR: Unable to run arp command on docker : %s", err)
		return err
	}
	/*Install ARP entry in host*/
	arpCmd = fmt.Sprintf("%s %s %s %s", "arp", "-s", dockerIP, dockerMAC)
	_, err = exec.Command("sh", "-c", arpCmd).Output()
	if err != nil {
		log.Println("ERR: Unable to run arp command on host: %s", err)
		return err
	}
	return nil
}

func runCommandOnContainer(ctx context.Context, cli *client.Client, containerId string, cmdlist []string) error {
	config := &types.ExecConfig{
		Cmd: cmdlist,
	}
	id, err := cli.ContainerExecCreate(ctx, containerId, *config)
	if err != nil {
		log.Println(err)
		return err
	}
	err = cli.ContainerExecStart(ctx, id.ID, types.ExecStartCheck{})
	if err != nil {
		log.Println(err)
		return err
	}
	return nil
}

func dockerRemoveInstances(remove_inst int) error {
	ctx := context.Background()
	cli, err := client.NewClientWithOpts(client.WithVersion(DOCKER_CLIENT_VERSION))
	if err != nil {
		fmt.Printf("\nERR:Unable to create new docker client : %s", err)
		return err
	}
	containers, err := cli.ContainerList(ctx, types.ContainerListOptions{})
	if err != nil {
		return err
	}
	containers_removed := 0
	for _, container := range containers {
		container_name := strings.TrimPrefix(container.Names[0], "/")
		if strings.HasPrefix(container_name, CONTAINER_PREFIX) {
			/*Remove container*/
			err = cli.ContainerRemove(ctx, container_name, types.ContainerRemoveOptions{
				Force: true,
			})
			if err != nil {
				log.Printf("ERR: Unable to remove container %s : %s", container_name, err)
				return err
			}
			containers_removed++
			log.Printf("STAT: Container %s removed . %d/%d", container_name, containers_removed, remove_inst)
			if containers_removed == remove_inst {
				log.Printf("STAT: removed %d container. Done!", containers_removed)
				return nil
			}
		}
	}
	return nil
}

func findMissingAgents() error {
	ctx := context.Background()
	cli, err := client.NewClientWithOpts(client.WithVersion(DOCKER_CLIENT_VERSION))
	if err != nil {
		fmt.Printf("\nERR:Unable to create new docker client : %s", err)
		return err
	}
	containers, err := cli.ContainerList(ctx, types.ContainerListOptions{})
	if err != nil {
		return err
	}
	var cmdlist []string
	cmdlist = append(cmdlist, "cat")
	cmdlist = append(cmdlist, AGENT_CONFIG_FILE)
	config := &types.ExecConfig{
		Cmd:          cmdlist,
		AttachStderr: true,
		AttachStdin:  true,
		AttachStdout: true,
		Tty:          true,
		Detach:       false,
	}
	for _, container := range containers {
		container_name := strings.TrimPrefix(container.Names[0], "/")
		id, err := cli.ContainerExecCreate(ctx, container.ID, *config)
		if err != nil {
			log.Printf("STAT: Agent missing : %s", container_name)
			continue
		}
		execAttachConfig := types.ExecStartCheck{
			Detach: false,
			Tty:    true,
		}
		containerConn, err := cli.ContainerExecAttach(ctx, id.ID, execAttachConfig)
		if err != nil {
			log.Printf("STAT: Agent missing : %s", container_name)
			continue
		}

		for {
			buf := make([]byte, 4096)
			length, err := containerConn.Reader.Read(buf)
			if err != nil {
				break
			}
			var device map[string]interface{}
			err = json.Unmarshal(buf[:length], &device)
			if err != nil {
				log.Printf("STAT: Agent missing : %s", container_name)
				break
			}
			deviceid, ok := device["DeviceId"].(string)
			if !ok {
				log.Printf("STAT: Agent missing : %s", container_name)
				break
			}
			if len(deviceid) == 0 {
				log.Printf("STAT: Agent missing : %s", container_name)
				break
			}
		}
	}
	return nil
}

func findDeviceId(deviceid string) error {
	log.Printf("STAT: going to look for deviceId : %s", deviceid)
	ctx := context.Background()
	cli, err := client.NewClientWithOpts(client.WithVersion(DOCKER_CLIENT_VERSION))
	if err != nil {
		fmt.Printf("\nERR:Unable to create new docker client : %s", err)
		return err
	}
	containers, err := cli.ContainerList(ctx, types.ContainerListOptions{})
	if err != nil {
		return err
	}
	var cmdlist []string
	cmdlist = append(cmdlist, "cat")
	cmdlist = append(cmdlist, AGENT_CONFIG_FILE)
	config := &types.ExecConfig{
		Cmd:          cmdlist,
		AttachStderr: true,
		AttachStdin:  true,
		AttachStdout: true,
		Tty:          true,
		Detach:       false,
	}
	for _, container := range containers {
		id, err := cli.ContainerExecCreate(ctx, container.ID, *config)
		if err != nil {
			log.Println(err)
			return err
		}
		execAttachConfig := types.ExecStartCheck{
			Detach: false,
			Tty:    true,
		}
		containerConn, err := cli.ContainerExecAttach(ctx, id.ID, execAttachConfig)
		if err != nil {
			log.Print(err)
			return err
		}

		for {
			buf := make([]byte, 4096)
			length, err := containerConn.Reader.Read(buf)
			if err != nil {
				break
			}
			var device map[string]interface{}
			err = json.Unmarshal(buf[:length], &device)
			if err != nil {
				break
			}
			if deviceid == device["DeviceId"] {
				container_name := strings.TrimPrefix(container.Names[0], "/")
				log.Printf("STAT: Found deviceId %s in container %s", deviceid, container_name)
				return nil
			}
		}
	}
	log.Printf("STAT: Deviceid %s not found", deviceid)
	return nil
}

func main() {
	var num_inst int
	var install_interval int
	var remove_inst int
	var deviceid string
	var missing_agent bool
	var del_arp_entries bool
	flag.IntVar(&num_inst, "n", 10, "specify num of instances")
	flag.IntVar(&install_interval, "i", DOCKER_CREATION_INTERVAL_OFFSET, "interval in seconds between instances")
	flag.IntVar(&remove_inst, "r", -1, "number of instances to remove. 0 means all")
	flag.StringVar(&deviceid, "f", "", "deviceid to be found")
	flag.BoolVar(&missing_agent, "m", false, "search for missing agent")
	flag.BoolVar(&del_arp_entries, "d", false, "delete ARP entries")
	flag.Parse()
	brmac, brip := GetIntfMACIP(DOCKER_INTERFACE)
	if len(brmac) == 0 || len(brip) == 0 {
		log.Printf("ERR: Invalid bridge mac %s or ip %s", brmac, brip)
		return
	}
	if del_arp_entries {
		deleteARPEntries(DOCKER_INTERFACE)
		return
	}
	if missing_agent {
		findMissingAgents()
		return
	}
	if remove_inst != -1 {
		log.Printf("STAT: going to remove instances")
		dockerRemoveInstances(remove_inst)
		return
	}
	if len(deviceid) > 0 {
		findDeviceId(deviceid)
		return
	}
	log.Printf("STAT: Going to run with the following config :")
	log.Printf("Number of instances = %d\n", num_inst)
	log.Printf("Interval between instances = %d\n", install_interval)
	log.Printf("Docker Bridge MAC = %s,IP = %s\n", brmac, brip)

	con_suffix := time.Now()
	for i := 0; i < num_inst; i++ {
		rand.Seed(time.Now().UnixNano())
		dockerCreationInterval := install_interval + rand.Intn(30)
		container_name := fmt.Sprintf("%s-%s-%d", CONTAINER_PREFIX, con_suffix.Format("2006-01-02--15-04-05"), i+1)
		log.Printf("STAT: Container  %d/%d started", (i + 1), num_inst)
		dockerStartAiagent(brmac, brip, container_name)
		time.Sleep(time.Duration(dockerCreationInterval) * time.Second)
	}
}

func GetIntfMACIP(intf_name string) (string, string) {
	itf, _ := net.InterfaceByName(intf_name) //here your interface
	mac := itf.HardwareAddr.String()
	item, _ := itf.Addrs()
	var ip net.IP
	for _, addr := range item {
		switch v := addr.(type) {
		case *net.IPNet:
			if !v.IP.IsLoopback() {
				if v.IP.To4() != nil { //Verify if IP is IPV4
					ip = v.IP
				}
			}
		}
	}
	if ip != nil {
		return mac, ip.String()
	} else {
		return mac, ""
	}
}

func inc_host(ip net.IP) {
	for j := len(ip) - 1; j >= 0; j-- {
		ip[j]++
		if ip[j] > 0 {
			break
		}
	}
}

func deleteARPEntries(intf_name string) error {
	mn := new(MyNet)
	itf, _ := net.InterfaceByName(intf_name) //here your interface
	item, _ := itf.Addrs()
	var ip net.IP
	for _, addr := range item {
		switch v := addr.(type) {
		case *net.IPNet:
			if !v.IP.IsLoopback() {
				if v.IP.To4() != nil { //Verify if IP is IPV4
					ip = v.IP
					mn.IP = addr.(*net.IPNet)
					mask, _ := strconv.ParseInt(strings.Split(mn.IP.String(), "/")[1], 10, 64)
					mn.Subnet = ip.Mask(net.CIDRMask(int(mask), 32))
					break
				}
			}
		}
	}
	ctr := 0
	for ip := mn.Subnet; mn.IP.Contains(ip); inc_host(ip) {
		arpCmd := fmt.Sprintf("%s %s %s", "arp", "-d", ip)
		_, err := exec.Command("sh", "-c", arpCmd).Output()
		ctr++
		if ctr > MAX_HOSTS {
			return nil
		}
		if err != nil {
			//log.Println("ERR: Unable to run arp delete command on host: %s", err)
			continue
		}
	}
	return nil
}
