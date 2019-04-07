#!/usr/bin/python3
# Author: Daniel N. Gisolfi, Michael Gutierrez
# Purpose: to create a connection to the RabbitMQ queue and send all attacks as messages
# Date: 2018-07-31

import os
import sys
import pika

host = '10.11.17.26'
msg_queue = 'honeynet'

def connect():
    #For local host use: connection = pika.BlockingConnection(pika.ConnectionParameters(host='NAME OF CONTAINER'))
    parameters = pika.URLParameters('amqp://admin:bigchoke@' + host +':30672/')
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()
    channel.queue_declare(queue=msg_queue)
    return connection, channel

def sendMsg(payload):
    try:
        connection, channel = connect()
    except pika.exceptions.AMQPConnectionError:
        print("connection failed")
        return 'Error sending to Rabbit, Connection Failed'

    try:
        channel.basic_publish(exchange='', routing_key=msg_queue, body=payload)
        print(f'Sending:{payload} \nTo: {msg_queue}')
        connection.close()
    except:
        print("Publishing error")
        return 'Error sending to Rabbit'
    
    return 'Message sent to Rabbit'
