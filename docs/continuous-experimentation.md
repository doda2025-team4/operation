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

The routing will be setup such that the canary app only sends requests to the canary model service, while the normal app only sends requests to the normal model service. The split of the traffic will be 90/10, meaning that 90% of the users will use the normal app and 10% will use the canary app.


