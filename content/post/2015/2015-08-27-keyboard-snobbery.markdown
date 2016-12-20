+++
layout = "single"
title = "Keyboards and how they work: An Introduction"
date = "2015-08-27"

+++

Over the past few months, I have been exploring the interesting (and expensive) world of keyboards. 
Yes, keyboards. There are a couple of resources on the subject that I owe all this knowledge to, namely the [geekhack forums](http://geekhack.org), the [TMK firmware source code](https://github.com/tmk/tmk_keyboard), the [deskauthority forums](http://deskthority.net), and of course lots of trial and error. The excellent [Linux Kernel Map](http://makelinux.net/kernel_map/) came in really handy for the software bits, and I highly recommend looking into it.

My path down this road came from a desire to build an [ergodox](http://www.ergodox.org/) keyboard when I saw one for sale on massdrop. I snatched one up, waited a couple of months, and when it arrived, busted out the soldering iron and got to work. I didn't take any photos of the process, but there are plenty of build logs with great photos all over the internet, many of them on [Reddit MechanicalKeyboards](https://www.reddit.com/r/MechanicalKeyboards/). My build was uneventful, greatly aided by a multimeter and lots of patience. My real interest started not after building and learning how to type on this, but after cracking open the TMK firmware and seeing how it all works. 

Programming a microcontroller to do anything with a modern computer is a lot of fun, and this, and a few other projects I'll discuss later led me down a bunch of interesting rabbit holes I had not encountered programming as a professional, ever.

## How does a keyboard work?

Some of this is cribbed from the well-written guide at [Massdrop's Introduction to Keyboard Programming](https://www.massdrop.com/article/introduction-to-keyboard-programming) written by HaaTa, a huge contributor to both the aforementioned forums, and an expert in his own right. He wrote an alternative firmware for keyboards as well, called [Kiibohd](https://github.com/haata/kiibohdforce) that supports a variety of microcontrollers.

A keyboard is a matrix of switches attached to a microcontroller that polls the states of the individual switch on that and then sends the resulting keycode to a piece of software running on the controller which translates the raw keycode into one that the USB-HID standard understands.

To understand this more deeply we can model this on a hypothetical keyboard with 12 keys (switches). 

![12 Key Schematic](/12keykeyboard.jpg)

That graphic came from [this PDF](http://nptel.ac.in/courses/Webcourse-contents/IISc-BANG/Microprocessors%20and%20Microcontrollers/pdf/Teacher_Slides/mod3/M3L7.pdf), but I don't know much about the material it came from.

The microcontroller is scanning the rows and the columns on the lines that the switches are attached to, so when the corresponding row and column go low, the controller can use this to translate it into a scancode which will send the desired keypress. 

As far as a PS/2 keyboard or terminal keybord, that is about it. In that world, this would generate an interrupt on the IRQ path, the lookup table in the OS would check the scancode against a keycode table (ASCII in linux vty) and the character would print or do whatever the intended control code was meant to do.

We can see this in the linux source code, in the [drivers/tty/vt/keyboard.c](http://lxr.free-electrons.com/source/drivers/tty/vt/keyboard.c) file. The interesting bit starts around line 154.

There is a decent summary of some of this information in the [Wikipedia entry for scancodes](https://en.wikipedia.org/wiki/Scancode#PC_compatibles).

Thankfully, we don't use PS/2 or terminal keyboards in most cases anymore. The USB-HID protocol allows for quite a bit of flexibility that would be impossible without a kernel recompile otherwise. Your keyboard is likely attached to the USB bus, even if it is on a laptop, and there are quite a few layers of abstraction between scancodes, keycodes, and your computer doing anything at all at this point.

We will follow up with a discussion of what happens next in a little while.
