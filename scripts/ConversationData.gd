extends Node

var conversations = [
	{
		"original": "שלום, נעים להכיר (Hello, nice to meet you)",
		"context": "Your friend's date just greeted him",
		"choices": [
			{"text": "She says hello and nice to meet you", "score": 2, "reaction": "Good start!"},
			{"text": "She's asking about your salary", "score": -5, "reaction": "WHAT?! Why would you..."},
			{"text": "She wants to know if you're single", "score": -2, "reaction": "Dude, we just met..."},
			{"text": "She says you look like her ex", "score": -8, "reaction": "*glares at you*"}
		]
	},
	{
		"original": "אני אוהבת לטייל בטבע (I love hiking in nature)",
		"context": "She's talking about her hobbies",
		"choices": [
			{"text": "She loves hiking and being in nature", "score": 3, "reaction": "Nice! I love hiking too!"},
			{"text": "She wants to climb mountains with you", "score": 1, "reaction": "That's... specific?"},
			{"text": "She hates staying indoors", "score": -1, "reaction": "Hmm, that's not quite..."},
			{"text": "She says you look out of shape", "score": -6, "reaction": "WHY would she say that?!"}
		]
	},
	{
		"original": "המשפחה שלי מאוד חשובה לי (My family is very important to me)",
		"context": "She's getting more personal",
		"choices": [
			{"text": "Family is really important to her", "score": 4, "reaction": "That's beautiful"},
			{"text": "She wants to meet your parents soon", "score": -3, "reaction": "Isn't it too early for that?"},
			{"text": "She comes from a big family", "score": 1, "reaction": "That's nice to know"},
			{"text": "She thinks your family is weird", "score": -7, "reaction": "She doesn't even know them!"}
		]
	}
]
