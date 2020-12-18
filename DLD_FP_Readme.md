
# Push Button. Get Image

A VHDL project that creates a Finite State Machine where each time we switch between states, we output a different image to the VGA monitor, and states are cycled through using a button on the Basys 3 board. Also, the current image that is being displayed also corresponds to an LED being lit up on the board. 

## How to use the hardware

The hardware we are using for this project is the Basys 3 board, for use with the Vivado design suite. The way that our project uses the hardware is with the down button, which is programmed to switch states. Whenever you press the down button, a different image will appear, cycling between 4 different images and the corresponding LED for each image will light up.

## Assumptions

There weren't really any assumptions that we had to make for this project, other than assuming that the user has a basys 3 board and knows how to push a button.

## Goals

Use the Basys 3 board to show ROM images using the buttons on the board to switch which image is showing. We would also like to make the images bigger to be able to see them clearly. If possible and time permits change color of the images using a gradient technique.

## Roadblocks

We encountered a lot of problems with signals and ports being used or unused when they should be or shouldn’t be. The port errors were hard for us to figure out what they were due to the fact none of us had seen what they were or how to fix them thankfully Kent was able to help us and show us how to fix them. Another problem we encountered was sometimes the button doesn’t switch the image but it will work if we click it again, we were unable to find the fix to this for the moment but its not a huge code breaking problem

## Hardware diagram

![Hardware Diagram](./Hardware_Design.PNG)

## Works Cited

We used Kent's ic_25 and ic_27 as guidelines for this project. We got all of our information on how to program the VGA board and display characters to the screen from ic_27 and all of our information on the finite state machine from ic_25, as well as help from Kent himself. 

## Authors

* **Ben Greenwood** - *Group Member* 
* **Brycen Martin** - *Group Member* 
* **Niklas Roberts** - *Group Member* 







