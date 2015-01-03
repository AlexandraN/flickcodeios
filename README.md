flickcodeios
============

Flick Code iOS (Custom Keyboard for iOS).
Uses a special alphabet, made of swipes. 
Destined for blind people and drivers who want to text while keeping the eyes on the road.

I filed three feature requests to Apple, https://bugreport.apple.com.
Continuing the project is possible.
We just have to tell the user how it works:
- it's necessary to have Voice Over typing mode "standard typing" while using Flick Code
- the swipe up/down behavior: the Voice Over speaks the letters, words,
etc. depending on the selected rotor option, even though the text view doesn't have the
accessibility focus, but it's the keyboard that has the focus.

Next steps:
- if the "learn mode" is on, each time the user opens the app, Voice Over reminds them about the
two touch long tap (or magic tap)
- the text view must be adapted so that the text won't be hidding under the keyboard
- create the options screen (create text, sms, call, e-mail, Twitter, web search, reset, settings, help)
- make the options screen the first screen.
- the copy, past, cut will be available on long press (or magic gesture or something) on the text
- the settings screen (toggle beginner mode, language)
- remember the website.
- the next screens have one or more text fields, depending on the selected option. For e-mail 
we'll need: destination (more people), subject, content
- give a little bit for free: "create text" and "call" options. And add the rest as in-app purchases.

More thinking:
- our users are blind or poorly sighted (or they are driving), so putting everything on the same screen (for example when it comes to sms or e-mail creation) is a bad idea. A better idea would be to make separate screens for all types of input.
For the sms creation, i.e., we could create a screen for the text of the sms and a table screen for the destinations.
It could be a normal, standard editable table.

The alphabet is in the file flickcodeios/Custom Keyboard Learn/Custom Keyboard Learn/code.json
