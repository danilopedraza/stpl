# Examples of the language

## A/B session style program

This is the definition of a part of Starting Strength with initial weights:

```
Session A:

Squat 3x5x120kg
Press 3x5x40kg
Deadlift 1x5x130kg

Session B:

Squat 3x5x120 kg
Bench 3x5x60 kg
Row 3x5x50 kg
```

Maybe this can be confusing. This can be read as a program with the weights fixed (you always do this exact routine). But... Why would you do that?

The definition of a program without initial weights (this is more of a scheme for a program):

```
Session A:

Squat 3x5
Press 3x5
Deadlift 1x5

Session B:

Squat 3x5
Bench 3x5
Row 3x5
```

I like this more, since it gives the idea that the weights are variable (as they should be).

There should be a way to specify how the program changes over time. That will complete the definition. I think of something like this:

```
Session A:

Squat 3x5
Press 3x5
Deadlift 1x5

Session B:

Squat 3x5
Bench 3x5
Row 3x5

Squat goes up 2.5kg every time
Bench goes up 2.5kg every time
Press goes up 2.5kg every 2 times
Row goes up 2.5kg every 2 times
Deadlift goes up 5kg every time
```

But this seems kinda strange: I could put the progression schemes in the same place where I put the prescription for the exercises. Something like this:

```
Session A:

Squat 3x5 with 2.5kg more
Press 3x5 with 2.5kg more every 2 times
Deadlift 1x5 with 5kg more

Session B:

Squat 3x5 with 2.5kg more
Bench 3x5 with 2.5kg more
Row 3x5 with 2.5kg more every 2 times
```
