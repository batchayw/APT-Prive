package main

import (
    "fmt"
    "os/exec"
)

func main() {
    cmd := exec.Command("bash", "-c", "/usr/local/bin/update-repo.sh")
    out, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Println("Error updating repository:", err)
        fmt.Println("Output:", string(out))
        return
    }
    fmt.Println("Repository updated successfully:", string(out))
}