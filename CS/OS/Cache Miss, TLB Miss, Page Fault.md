## 1. Definitions

### 1.1 Cache

The cache is like RAM, but it's close to the CPU.

Instead of going all the way through the RAM to access the necessary data, the CPU can get the data from the cache faster.

However, if the data doesn't exist in the cache, there will be a cache miss.

<br>

### 1.2 TLB

We can think of TLB as a memory cache.

It reduces the time taken to access a memory location.

**We also call it to `address translation cache`, since it stores the recent translations of virtual memory to physical memory.**

<br>

### 1.3 Page Table

The virtual memory system is an operating system uses it as a data structure.

It stores *the mapping between virtual memory and physical memory.*

The memory management unit handles this specific translation.

<br>

The page table has a `flag` for each item that indicates if the related page is physical memory or not.

The page table entry includes the physical memory address where the page is stored *if it’s in the physical memory.*

**However, if the hardware makes a reference to a page, and the page table entry for the page indicates that it's not in the physical memory, pafe fault occurs.**

This invokes the operating system’s paging supervisor component.

<br>

## 2. Memory Hierarchy

Without memory hierarchy, it would be almost impossible for programmers to have unlimited amounts of fast memory. 

According to the principle of locality, most programs don’t access all code or data uniformly. 

As a result of this principle, combined with the smaller hardware is faster perspective, memory hierarchies vary in speed, cost and size. 

We can see the different levels of memory hierarchies in the figure below:

![image](https://github.com/lielocks/WIL/assets/107406265/4bbeffe3-64f4-4102-bd86-6e48c75c30e4)

<br>

### 2.1 Why Do We Need a Cache, TLB, and Virtual Addressing?

The goal is to provide a memory system with a lower cost, faster access, and larger area. 

This leads to different solutions at different levels. 

**Caches improve the performance of CPUs; instead of going all the way to the memory, the CPU can `directly access` the caches.** 

Furthermore, *virtual memory makes physical memory infinite* to programmers. 

By using virtual addressing, physical memory plays the role of cache for disks.

<br>

When we need a cache for virtual addressing, **`TLB`** comes into the stage and acts as a **cache for virtual memory.** 

It’s a kind of special cache for *recently used translation of addresses.* 

The operating system handles TLB misses as exceptions. 

It has a simple replacement strategy since TLB misses happen frequently.

<br>

When we look at the overall view, we can see that the caching mechanism has a crucial role in the memory hierarchy. 

It doesn’t only affect the performance on the hardware level, the mechanism itself leads to solving other issues in other abstraction levels as well.

<br>

## 3. Cache Miss, TLB Miss, and Page Fault

Before getting into too many details about cache, virtual memory, physical memory, TLB, and how they all work together, let’s look at the overall picture in the figure below: 

We’ve simplified the below diagram so as not to consider the distinction of first-level and second-level cashes because it’s already confusing where all the bits go:

![image](https://github.com/lielocks/WIL/assets/107406265/9942dc5a-9294-4842-94ad-5c9c07e86a34)

First, we can see the **virtual address** is logically divided into a **page number and page offset.**

The page number is sent to the TLB; if the TLB match is a hit, then *the physical page number is sent to the cache tag* to control whether it’s a match. 

If it matches, it’s a cache hit. **Otherwise, it’s a cache miss.** 

In this case, we use the physical address to get the block from memory, and the cache will be updated.

<br>

**`TLB miss`** occurs if **we don’t find the page inside the TLB.** 

In this situation, we go to the *page table* to look for the corresponding page. 

If we **can’t find the corresponding page in the page table, then `page fault` occurs.** 

In this case, we read the page from the *disk via the operating system.*

<br>

When we transfer the page into memory, the memory can be full. 

In this case, we’ll find a `victim page` and *overwrite the victim page with the new page, P.* 

Then we’ll update the page table and TLB.

<br>

This is how the overall mechanism works under the hood. 

We’ve simplified some parts to share the main idea behind all these concepts. 

When we go into details, we’ll see there are different cache levels, as well as different types of TLBs coming into the stage to solve the issues in the memory hierarchy.

<br>

## 4. Differences Between Caches and Virtual Memory

Although many terms are different, *the cache is similar to virtual memory* in some ways. 

Page or segment is like a `block`, and as a result, page fault or address fault corresponds for `miss`. 

As we’ve previously mentioned in this article, *the CPU generates virtual addresses.*

<br>

Hardware and software cope with these addresses and translate them into physical addresses which access the main (physical) memory. 

We call this process `memory mapping` or `address translation`.

**There are also other differences between caches and virtual memory:**

+ *Hardware* is responsible for the replacement on cache misses.

  However, the *OS* controls the virtual memory replacement.

+ *The size of virtual memory* depends on the size of the **processor address,**

  while the cache size isn't related to the processor address size.

+ Virtual memory is not only a lower-level backing store for Main Memory, but also storage for the **File System**

