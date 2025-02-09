use std::env;
use bollard::Docker;

#[cfg(unix)]
Docker::connect_with_socket_defaults();

fn main() {
    let args: Vec<String> = env::args().collect();
    
    let command = &args[1];
    let argument = &args[2];

    println!("command: {command}");
    println!("argument: {argument}");
    if command == "install" {
        println!("installing {argument}");
    } else {
        println!("unknown command");
    }
}
