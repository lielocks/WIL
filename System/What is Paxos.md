## Introduction to Paxos Algorithm and Its Importance

### What is Paxos?

![image](https://github.com/lielocks/WIL/assets/107406265/33d06334-7f76-4b16-b95d-e2a52de519a0)

Paxos is a family of distributed algorithms designed to achieve consensus among a network of computers or nodes. 

The term "family" indicates that there are several variations of the algorithm, but here, we'll focus on the **`"vanilla" Paxos`** algorithm.

+ **Distributed** : Runs on a set of computers or nodes.
  
+ **Consensus** : Agreement on a single data value among distributed nodes.
  
The Paxos algorithm was first proposed in a seminal paper listed at the bottom of the slide.

<br>

### What is to reach consensus with Paxos?


**`Consensus`** is agreeing on one result.

Once a majority agrees on a proposal in the Paxos world, that would be considered consensus.

So once three people know they want to go for dinner, everyone will go for dinner.

It only may take some time for them to figure out.

Any reached consensus can be eventually known by everyone.

They could ask around whether a consensus was reached, and what the agreement was.

In Paxos, the involved parties want to agree on any result, not on their proposal, so they will contribute towards **reaching consensus.**

And finally, communication channels may be faulty, that is messages can get lost.

In this case you observe that someone wasn't listening, they proposed a different thing to do, in the end an agreement was reached.

<br>




### Understanding Consensus with Paxos

![image](https://github.com/lielocks/WIL/assets/107406265/848cd59b-8fe7-4f85-a3d1-98f415998f42)

**What is to reach consensus with Paxos?**

Imagine you and your friends need to agree on an activity for the afternoon. 

Here's how **consensus** might look:

1. Proposing an Idea: One person suggests going to the cinema.

2. Backing a Proposal: Some friends agree, while others propose different ideas, like going to dinner.

3. Reaching Agreement: Eventually, some friends change their minds, and everyone agrees to one activity, like going to dinner.

<br>

In the Paxos world:

+ **`Consensus`** is reached when a majority agrees on a proposal.

+ Once a majority agrees, the proposal is accepted by everyone, though it may take time to propagate the decision.

<br>

### Why do systems need to reach Consensus

Imagine you have a workstation at your home.

![image](https://github.com/lielocks/WIL/assets/107406265/78b6426b-6152-40a8-ad20-bf2781d49a55)

You write a server, you make it public, you start getting visits from people, and it's kind of becoming a success.

So more and more people are using it, and at some point your computer is too slow.

You're running out of resources.

So you upgrade the RAM, upgrade the CPU, and it happens again.
It's still-- more and more people using it.
You upgrade it again. But that has a limit.
You can't have an infinitely powerful and scalable single computer.

You have to go for something different.

You either go for a **`leader-replicas schema`**, in which one node is the leader and the other nodes are **replicas.**

And whenever someone wants to propose writing a value, they would talk to the leader, and the leader would serialize the different proposals and send them to all the replicas.

All the data would be written in all these nodes.

Or you go for a **`peer-to-peer schema`**, in which all nodes are the same and behave the **same.**

And whenever they want to propose a new value, they send the proposals to each other to agree on what is the next proposal to be accepted, to be performed by everyone, so that everything is applied in the same order everywhere, eventually.

*In the first case* if the leader becomes unavailable, nodes must reach consensus to elect a new one.
Otherwise, the whole system would be stalled.

*In the second one,* the nodes must reach consensus continuously, so as to guarantee consistency so that operations are applied in the same order everywhere.

<br>

*<Summary>*

In distributed systems, achieving consensus is crucial for several reasons:

  1. Scalability and Redundancy: When a single computer can't handle the load, multiple nodes are used.

  2. Leader-Replica Model: One node acts as a leader, and others are replicas. Consensus is needed if the leader fails and a new leader must be elected.

  3. Peer-to-Peer Model: All nodes are equal. Consensus ensures that all nodes apply operations in the same order, maintaining consistency.

<br>

### Paxos Basics

**Roles in Paxos**

![image](https://github.com/lielocks/WIL/assets/107406265/d1b00800-2592-4047-9429-930b08dd74f1)

Paxos defines three main roles:

1. **Proposers** : Propose values to reach consensus.

2. **Acceptors** : Contribute to reaching consensus.

3. **Learners** : Learn the agreed-upon value, which can be queried later.

Nodes can take multiple roles simultaneously.

<br>


**Key Properties**

+ Majority Agreement: Paxos requires a majority of acceptors to agree on values, ensuring any two majorities will overlap at least once.

+ Persistence: Paxos nodes must not forget accepted values, even if messages are lost.

+ Single Consensus per Run: Each Paxos run aims at reaching consensus on one value only.

<br>

## The Paxos Algorithm

![image](https://github.com/lielocks/WIL/assets/107406265/eb85f56f-807b-4b18-a219-a0a8f987dfb0)

1. Prepare Phase:

+ The proposer sends a PREPARE message with a unique ID to all acceptors.

+ Acceptors promise to ignore requests with lower IDs.

<br>

![image](https://github.com/lielocks/WIL/assets/107406265/0cf05a8e-67b2-4d33-975d-94756a029ec7)

2. Promise Response:

+ If an acceptor hasn't promised a higher ID, it responds with a PROMISE message.

+ If it has previously accepted a value, it includes this in the PROMISE.

<br>

![image](https://github.com/lielocks/WIL/assets/107406265/f3038afa-2088-4120-a218-e7f28b108559)

3. Accept Phase:

+ The proposer sends an ACCEPT REQUEST with the highest ID and proposed value to all acceptors.

+ Acceptors accept the request if it matches their promise.

<br>

4. Acceptance:

+ When a majority of acceptors accept a value, consensus is reached.

+ Acceptors and learners are informed of the accepted value.

<br>

### Handling Multiple Proposers

If multiple proposers are active, contention can occur, causing delays. 

This can be mitigated with strategies like exponential backoff, allowing one proposal to complete before others proceed.

<br>


### Practical Case: Distributed Storage System

![image](https://github.com/lielocks/WIL/assets/107406265/52e7d2e6-4594-423f-a3d5-388d7b86c974)

Consider a distributed storage system (inspired by Megastore), where user data, like bank account balances, is replicated across multiple nodes. 

Paxos ensures that all replicas agree on the state of the account.

<br>


### Example Workflow

1. Initial State: Log position 0 records the opening balance.

2. Updating State: Each transaction (e.g., deposit, withdrawal) is recorded in subsequent log positions.

3. Client Interaction:

+ Clients interact with storage servers, which act as Paxos nodes.

+ For a write operation (e.g., withdrawal), the storage server proposes a new log entry.

+ Paxos ensures all replicas agree on the new state.

<br>

By ensuring consensus, Paxos maintains data consistency across distributed systems, making it a cornerstone of reliable and fault-tolerant distributed computing.
