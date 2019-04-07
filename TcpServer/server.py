#!/usr/bin/python3
import os
import sys
import uuid
import socket
import datetime
from SendToQueue import *

class Server:
    def __init__(self, port):
        self.sock = None
        self.host = None
        self.port = port
        self.ver = 1.0
        # Honeypot details
        self.honeypot = 'SSH-Honeypot'
        self.honeypot_version = os.getenv('VERSION', '02')
        self.id = self.honeypot[:3] + self.honeypot_version
        self.host_ip = os.getenv('VERSION', '10.11.17.23')
        self.host_name = socket.gethostname()
        self.pid = os.getpid()
        self.hpid = uuid.uuid4()
        self.method = 'SSH'
        
        self.setupSocket()

    def setupSocket(self):
        # Get new socket object
        self.sock = socket.socket()
        # Get hostname of the Docker Container
        self.host = socket.gethostname()
        try:
            # Now bind that port to the Socket!!
            self.sock.bind(('', self.port))
        except OSError:
            print('Error Port already in use')
       

    # Logging to ensure we arent losing any data
    def logger(self, log):
        try:
            file = open('server.log', 'a+')
            file.write(log + '\n')
            file.close()
        except:
            print('Server: Error logging to File!')

    def buildLog(self, msg):
        data = msg.split(',')
        log = f'{self.id},{datetime.datetime.now()},{self.honeypot},{self.host_ip},'
        log += f'{self.host_name},{self.pid},{self.hpid},{self.method},Null,'
        log += f'{data[0]},{data[1]},NULL,username={data[2]}&password={data[3]}'

        return log
    
    # Handle all incoming client connections
    def handleConnections(self):
        print(f'SocketStream Server v{self.ver}')
        try:
            # Wait for a client to connect to the Server
            print('Server: Listening for Messages...')
            self.sock.listen(5)
            while True:
                print('--------------------')
                conn, addr = self.sock.accept()
                print('Message Received from Client')

                # There should never be a message larger than this...
                msg = conn.recv(10096).decode()
                attack_log = f'[{datetime.datetime.now()}] Client: {addr[1]} Message: {msg}'
                print(attack_log)
                self.logger(attack_log)

                log = self.buildLog(msg)
                print(log)
                status = sendMsg(log)
                conn.send(f'Message Received Status: {status}'.encode())
                conn.close()
        except KeyboardInterrupt:
            print('Server: Shutting Down')
            sys.exit(1)
        
def main():
    server = Server(5050)
    server.handleConnections()
        

if __name__ == '__main__':
    main()