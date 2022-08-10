# hangman
TOP project. Files and Serialization Chapter.

# Gist
Classic Hangman(, the goal is to guess the word letter by letter. If you're got the letter right, it will be displayed in a word and blocked from entering again.) The point of the exercise was to implement the option to save the game and load it if you wish to continue.

# Approach 
The code is my cleanliest so far. I really feel that I have nailed the ruby-esque simplicity and clarity in this one. Dictionary is a file. The game suggests you to save after each attempt by dumping variable instances of the Game class to a .yaml file. Loading is done by parsing the said file.

# What Have I Learned
Serializing (YAML), manipulating files outside the IDE and being able to dump and retrieve certain data from outside of the code. Conciseness.