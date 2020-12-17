# Introduction to R objects

All types of data are treated as objects in R. An object is an **instance** of a particular **class**. Operations and functions are defined and tuned up for specific classes. You have already used objects several times when working with R. Consider these basics objects:

1. Atomic vectors
1. Lists
1. Matrices
1. Data frames

All of them have an structure to the data stored in them and an associated behaviour which lets you manipulate the data contained in them in a sensible way. You can also think of objects as an abstraction with attributes (values) and behaviours (actions). Consider, for instance, an object of the class _car_. A car object would have some attributes such as its maximum speed, its colour or the capacity of its gas tank. It would also have an associated behaviour such as a method to calculate its speed based on a given value or to calculate how much gas it will spend to traverse 90 km at a given speed.


## Classes, the very basics

Classes are like recipes to build objects. They also define their behaviour. There are two types of classes in R:

- S3: The most common type of class of the base packages and possibly, of CRAN packages. 
- S4: They are more formal, similar to the concept of class in other OOP languages such as C# or Java. 

There are several differences between them. Let's start by exploring S3 classes.

## S3 classes

Let's create an object of class **data.frame** and explore it:

````
bioinformatics_students <- data.frame(background=c('computational', 'life_sciences', 'other'), name=c('Marta', 'Santiago', 'Pedro'))
bioinformatics_students

     background     name
1 computational    Marta
2 life_sciences Santiago
3         other    Pedro

````
To check the class of the object **bioinformatics_students**, type:

````
class(bioinformatics_students)
[1] "data.frame"
````

Which attributes are associated with this object of class **data.frame**?

````
attributes(bioinformatics_students)
$names
[1] "background" "name"      

$class
[1] "data.frame"

$row.names
[1] 1 2 3
````
As you can see, the object **bioinformatics_students** has three attributes: names, class and row.names. For instance, to retrieve the data inside
**names**, you can type:

````
names(bioinformatics_students)
````

Now that we understand the attributes in this object, let's check which  methods are avaliable for this object. To do so, type:

````
methods(class='data.frame')
````
Why **data.frame** and not **bioinformatics_students**. All the methods we just retrieved are available for objects of class _data.frame_, no matter
their attributes. Attributes, on the other hand, contain values which are especific to the instance/object. 


## Functions vs methods

You may have seen functions before. But now we are talking about **methods**, so which is the difference?

A function is a piece of code that is called by name. It can be passed data to operate on (i.e. the parameters) and can optionally return data (the return value). All data that is passed to a function is explicitly passed.

A method is a piece of code that is called by a name that is associated with an object. In most respects it is identical to a function except for two key differences:

1. A method is implicitly passed the object on which it was called.
1. A method is able to operate on data that is contained within the class (remembering that an object is an instance of a class - the class is the definition, the object is an instance of that data).


## Our own S3 class

We can define new S3 classes. For instance:
````
Batman <- list(Name = "Batman", Age = 26, Power="Money")
class(Batman) <- "Hero"
````

Our hero instance of the _Hero_ class has three attributes: **Name, Age and Power**. To retrieve the data stored in them, we can type:

````
Batman$Power
[1] "Money"
````

Now, we will be adding a **function** to our class **Hero** to model its behaviour.

````
power <- function(object) {
UseMethod("power")
}
````
We are telling R that the **function** _power_ called with a single argument (object),
should  call the method **power**.

And next we have to tell R what to do when **power** is called on an object of class **Hero**:
````
power.Hero <- function(object) {
cat("You have the power of", object$Power, "\n")
}
````

No try to use your newly created method **power**:

````
power(Batman)
````

## What sets S3 classes apart from S4 classes

We previously discussed that S4 classes are more _formal_. Let's dig into the meaning of this assessment. Start by typing:

````
not_a_data_frame <- 'Fruit'
class(not_a_data_frame) <- 'data.frame'
````
Now, let's check it's attributes:

````
attributes(not_a_data_frame)
$class
[1] "data.frame"
````
R does not try to assess whether _Fruit_ constitutes a valid data.frame. It just tries to comply with the commands we just typed. 

## Why bother with S3 classes in the first place?
S3 is very simple and easy to implement but simplicity comes at the cost of trusting that objects belonging to a class have the correct components/slots etc. As we have seen, we can set the class of _Fruit_ to data.frame, which in turn allows us to use data.frame functions. However, there is no guarantee that these functions will work. S3 is easy to implement, document and requires less extra knowledge on the part of the programmer.


## S4 classes
You are likely to encounter S4 objects when working with state of the art bioinformatics libraries such as DESeq2 (Love et. al. 2014), so let's review the basics of S4 classes.

First type:

````
setClass("Student", slots=list(name="character", origin="character", id="numeric"))
student_s4 <- new("Student",name="María", origin="computational", id=42)
student_s4
````
You will get:
````
An object of class "Student"
Slot "name":
[1] "María"

Slot "origin":
[1] "computational"

Slot "id":
[1] 42

````
Ok, we have a lot of information to digest here. Take a look at the 'setClass' function. It has a name (class name), and then a list of three tuples.
Each define a class slot. Think of them as S3 attributes. But, If you take a closer look, you will notice that we are also defining which kind of data
types can fit each slot. For instance, the slot _name_ is of type _character_. 

You will also notice that typing:

````
student_s4$name 
````

no longer works, retuning instead:

````
Error in student_s4$name : $ operator not defined for this S4 class
````

To access **S4 objects slots**, we will use a different operator:

````
student_s4@name
````

You will also notice that we have used the ```new``` keyword. It tells R we are
instanciating a new object of class _Student_. It will also check if our input
fields (María, computational and 42) are of type character, character and numeric, respectively.

As you can see, S4 are more strict in terms of object creation. 

## Working with S4 objects

You can check if a given object is S4 by typing:

````
isS4(student_s4)
````
It will return ````TRUE```` if that's the case and ````FALSE```` otherwise.

To change the data stored in a given slot, type:

````
student_s4@name <- 'Marta'
````

Now, try to set the id, which we defined as **numeric** when we created the class.
But instead of using a number, let's test what happens If we try to set a character type instead.

```` 
student_s4@id <- 'test'
````

R will tell us that:

````
Error in (function (cl, name, valueClass)  : 
  assignment of an object of class “character” is not valid for @‘id’ in an object of class “Student”; is(value, "numeric") is not TRUE
````

Indeed, when we created the class **Student**, we explicitly told R that the slot **id** is of type **numeric**, and thus, characters
are not allowed.

As you might have guessed, S4 objects are more robust and their behaviour, more predictable. 

## Coding our own S4 methods

Type the following:

````
get_background <- function(object) {
UseMethod("get_background")
}
````
Again, we are telling R that the function get_background should call the method
**get_background** and pass the object.

````
setMethod("get_background", "Student", function(object) {
cat("This student background is:", object@origin, "\n")
}
)
````
And now we are telling R that the method **get_background** when called on objects
of class **Student** should execute the code in brackets.

````
get_background(student_s4)
This student background is: computational 
````

## Summary

1. All types of data are treated as objects in R.
1. S3 objects use the operator ````$```` to access their attributes.
1. S4 objects use the ````@```` to retrieve their slots.
1. S3 objects are more flexible, but you may break them inadvertedly.
1. S4 objects are formal, more robust, but are more strict in terms of manipulating them.