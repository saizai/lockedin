Locked-in Communication Protocol
================================

Sometimes you need to communicate with someone who is conscious and can see or hear you, 
but has only very limited means of communication (e.g. eye blinks, eye gaze direction, 
grunt, or single finger wiggle).

This aims to be a protocol for doing that, which:
* requires nothing more than information that will fit on a single credit card sized card
* can be used very quickly, with zero training, under severe stress
* makes two-way communication as efficient as possible
* alleviates as many of the common frustrations as possible
* makes minimal assumptions about what signals the subject can make


Protocol Overview
-----------------

1. Setup
    1.  Ask subject to enumerate all the signals they can make
        1.  Identify each by name (e.g. 'one blink', 'look left', etc.)
        2. In random order, ask subject to make each signal on the list
    2. Assign each signal, in order of ease, to the meanings on the list
        1. E.g. the simplest signal (e.g. one blink) would mean 'yes'
        2. In random order, ask subject to signal each meaning assigned
2. Q&A mode
    *  Meanings: yes, no, wrong question, need attention, switch mode, warmer, colder
    *  Questions to ask:
        1. ...
3. Spelling mode (binary)
    *  Meanings: first group, second group, backspace / mistake, switch mode, word break
4.  Spelling mode (ternary) [preferred, if enough signals available]
    *  Meanings: letter asked, before, after, backspace/mistake, switch mode, word break

Spelling mode
-------------

The worst case scenario is to go through the alphabet in order A-Z and ask the subject
to signal 'yes' when you hit the right letter. This is extremely inefficient, and
takes a long time, which makes communication more frustrating.

Instead, we use a modified binary or ternary search method.

For binary method, you look at the chart given for the next split to make - e.g.
'is the letter K or earlier, or L or later?' - and repeat until you find a signal
letter. On average, this takes about 4.3 questions per letter.

For ternary method, you look for which letter to ask about - e.g. 'is the letter
K, before K, or after K?'. This requires one more signal, but takes only ~3.3
questions per letter.

To make things even more efficient, we supplement the main tree with contextual
differences. For instance, after the letter j, the most frequent letters by far
are u, o, e, a, and i (in that order). Therefore, it's more efficient to ask
about those next than to start over as if you didn't have context.
