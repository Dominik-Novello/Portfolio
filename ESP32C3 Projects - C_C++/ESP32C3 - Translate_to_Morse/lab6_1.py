from gpiozero import LED
from time import sleep

morse_code_dict = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.',
    'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.',
    'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-',
    'V': '...-', 'W': '.--', 'X': '-..-', 'Y': '-.--', 'Z': '--..',
    '0': '-----', '1': '.----', '2': '..---', '3': '...--', '4': '....-', '5': '.....',
    '6': '-....', '7': '--...', '8': '---..', '9': '----.'
}

def text_to_morse_code(text):
    morse_code = ""
    for char in text:
        if char.upper() in morse_code_dict:
            morse_code += morse_code_dict[char.upper()] + " "
    return morse_code

def transmit_morse_code(morse_code, dot_duration):
    led = LED(17)
    print(morse_code)
    for symbol in morse_code:
        if symbol == '.':
            led.on()
            sleep(dot_duration)
            led.off()
            sleep(2 * dot_duration)
        elif symbol == '-':
            led.on()
            sleep(3 * dot_duration)
            led.off()
            sleep(2 * dot_duration)
        elif symbol == ' ':
            sleep(2.5 * dot_duration)


user_input = input("Enter the repetition number followed by the text to transmit in Morse code: ")
repetitions, text = user_input.split(' ', 1)
repetitions = int(repetitions)

morse_code = text_to_morse_code(text)

dot_duration = 0.2

for _ in range(repetitions):
    transmit_morse_code(morse_code, dot_duration)
    sleep(2.5 * dot_duration)
