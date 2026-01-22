# Continuous experimentation

## Feature difference to test
The feature difference between the A and B group is the implementation of a message length verification on the applications input field. Every message that the user tries to send, that has less than 6 characters, will not be sent to the backend. 

## Metric to measure
The metric that we will measure is the amount of requests per second that the backend receives from the application.

## Hypothesis
Our hypothesis is that by implementing this feature, the backend will receive fewer requests per second.

We think this will happen because some of the messages will be filtered out on the client side before even reaching the backend. This will reduce the load on the backend. In the worst case the messages that reach the backend will remain the same as before, but it will never give an increase in requests.

## Experiment design
The experiment will be designed as follows:

There will be versions both the application and the model service that will be deployed. One will have the length verification and be labeled as the canary, while the other will not have the length verification and won't have a specific label.

To see if the canary version will have fewer requests per second, we will send a sequence of requests containing a message from a predefined set. The messages will vary in length, some being shorter than 6 characters and some being longer. Both of the versions will receive the same sequence of requests.

Of the set of messages, half of them will be shorter than 6 characters, and the other half will be longer than 6 characters. This way we can see how the length verification affects the number of requests that reach the backend.

The sequence of requests will be of length 200.

## Results
After running the experiment, we observed the following results:

The control version had peaks of 3.64 requests per second for every run of the experiment. The canary version had peaks between 1.71 and 1.85 requests per second.

This indicates that the canary version received roughly half the amount of messages compared to the normal version. This aligns with the setup of our experiment, where half the possible messages were shorter than 6 characters and thus filtered out by the length verification feature. It varies a bit due to the randomness of the message selection.

## Conclusion
Based on the results of the experiment, we can conclude that our hypothesis was correct. The implementation of the message length verification feature did indeed reduce the number of requests per second that the backend received.

It is noteworthy that the real world reduction would depend on the actual distribution of the message lengths sent by the users. But this experiment has shown that the messages that are short, will not reach the backend, thus reducing the load on it.


