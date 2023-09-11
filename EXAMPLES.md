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

But... I'm not implementing it right now. 

Right now I need a way to write the work done in the training sessions, so I can create the next prescriptions. The first thing that comes to my mind is something like this:

```
Training session 1 (A):

Squat 3x5x60kg
Press 3x5x30kg
Deadlift 1x5x70kg

Training session 2 (B):

Squat 3x5x62.5kg
Bench 3x5x40kg
Row 3x5x35kg
```

This is enough to start. Now, I need to generate the training sessions. For this particular training program, the next prescription is generated with the log of (at most) the last two previous sessions. There are programs where every training session is fixed since the beginning, given some initial values (usually max loads of some movements). There are programs where every training session is independent of each other, and the loads are prescribed in place using effort or a range for selecting a load.

For the output format, I think a table is fine. Each row is a prescription for an exercise. This is an example of the expected generated third session from the two logs above (of type A):

| Exercise | Sets | Reps | Load |
| -------- | ---- | ---- | ---- |
| Squat    | 3    | 5    | 65kg |
| Press    | 3    | 5    | 30kg |
| Deadlift | 1    | 5    | 75kg |

We should be able to export the next training session in this format (a Markdown-formatted table that is fairly readable without rendering it) or in CSV. The CSV would be like this:

```
Exercise,Sets,Reps,Load
Squat,3,5,65kg
Press,3,5,30kg
Deadlift,1,5,75kg
```

Right now, this is kinda done. There are a lot of cases that I did not implemented yet, but the *happy path* is just fine.

## Periodized, percentage-based program

Now let's try to represent programs that make some longer-term adjustments. My example to follow is The Juggernaut Method 2.0. This program is more complex. It lasts four months maximum, with four stages (very similar between them) of one month each. For each exercise trained (basic JM 2.0 prescribes Strict Press and the powerlifts) there is a session each week. It goes like this (for Strict Press only, the others are exactly the same):

```
Week 1: 5x10x60% of TM (Training Max)
Week 2: 3x10x67.5% of TM
Week 3: 1xAMAPx75% of TM
Week 4: Something like 1x5x40%, 1x5x50%, 1x5x60%
```

Where AMAP is As Many As Possible. In addition to that, the last set of the first three sessions is also AMAP. Right now, I'm kinda surprised by the amount of details that I have to account for, and how to write them smoothly.

Each stage of this program has four stages: Accumulation, intensification, realization and deload. In the first three the intensity goes up as the volume goes down, and the deload is that - a deload.

I would like a session to be written like this:

```
Session 1, stage 1, intensification:
Squat 3x10x67.5% of TM
```

Later I would like to generalize more to make the program description more succinct, but this does just fine.
