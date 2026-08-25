# AVR-SpO2-Monitoring-System

## Overview

This project is an embedded system based on the ATmega32 microcontroller for measuring and displaying blood oxygen saturation (SpO2).

The system communicates with a pulse oximeter sensor, processes the received data, calculates the oxygen saturation level, and displays the results using an LCD and 7-segment displays. Measurement data can also be stored and retrieved using EEPROM memory.

## Features

- AVR Assembly language implementation
- ATmega32 microcontroller based system
- SpO2 measurement and data processing
- Pulse oximeter sensor interface
- LCD 16x2 display support
- 7-segment display control
- EEPROM data storage
- Keypad user interaction
- Proteus simulation

## Hardware Components

- ATmega32 Microcontroller
- Pulse Oximeter Sensor
- LCD 16x2 Module
- EEPROM Memory
- 7-Segment Display
- Keypad

## Software Tools

- AVR Assembly
- Proteus Design Suite
- AVR Development Environment

## System Description

The microcontroller receives data from the pulse oximeter sensor and processes the measured values to calculate SpO2 percentage based on oxyhemoglobin and deoxyhemoglobin levels.

The calculated results are displayed through the LCD and 7-segment displays. The system also supports saving measurement results in EEPROM for later access.

## Simulation

The complete circuit design and functionality were developed and tested using Proteus simulation software.

## Project Structure

Code: AVR Assembly source files

Proteus: Circuit simulation files

Images: Circuit and output screenshots

Documentation: Project documents
