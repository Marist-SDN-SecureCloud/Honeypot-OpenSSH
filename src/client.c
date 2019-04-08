// Source code found at: https://github.com/dgisolfi/SocketStream
// Author:  Daniel Nicolas Gisolfi
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define VER 1

int transmitMessage(int port, char *msg) {
    printf("SocketStream Client v%d\n", VER );

    struct sockaddr_in address; 
    int sock, read_value;
    struct sockaddr_in serv_addr;  
    char server_response[1024] = {0}; 

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) { 
        printf("Socket creation error\n"); 
        // exit(EXIT_FAILURE);
    } 
   
    memset(&serv_addr, '0', sizeof(serv_addr)); 
   
    serv_addr.sin_family = AF_INET; 
    serv_addr.sin_port = htons(port); 
       
    // Convert IPv4 and IPv6 addresses from text to binary form 
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr)<=0) { 
        printf("Invalid address\n"); 
        // exit(EXIT_FAILURE);
    } 
   
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) { 
        printf("Connection to Socket Failed\n"); 
        // exit(EXIT_FAILURE);
    } else {
        send(sock, msg, strlen(msg) , 0 ); 
        printf("Client: Message sent to Server\n"); 

        read_value = read(sock, server_response, 1024); 
        printf("Server: %s\n", server_response);

        printf("Client: Shutting Down\n"); 
    }
    
    return 0; 
}