Some generally-useful support bits for iOS and OSX development.

## Installation

``` sh
$ gem install cocoapods
$ edit Podfile
```

``` ruby
platform :ios, "5.0"
pod 'Clutter', :git => 'https://github.com/sagran/Clutter.git'
```


``` sh
$ pod install
```

## Usage
To get everything:

``` c
#include "Clutter.h"
```

See the generated DocSet, the headers, anything in Specs, and notes below for what's actually in here.

### `cl_error.h`
Think Objective-C does a terrible job with errors?  Tired of logging all these pesky NSErrors flying by? Miss your app
just crashing when it has problems? Well this is for you.

In a header, do this:

``` c
#include "cl_error.h"
#if DEBUG
#define ERROR(...) ERR_THROW(__VA_ARGS__)
#else
#define ERROR(...) ERR_LOG(__VA_ARGS__)
#endif
```

Rename your source files from foo.m to foo.mm.  You are now using Objective-C++.

Now any time you want to catch an error being returned, just use `ERROR()` as the function parameter:

``` objc
[obj initWithData:nil error:ERROR()]
```

Got an object on the stack? No problem! (Useful for branching on the state of error later on.)

``` objc
NSError *error;
[obj initWithData:nil error:ERROR(error)]
```

Implementing a function returning error? No problem!

``` objc
- (void)maybeError:(NSError **)error {
[obj initWithData:nil error:ERROR(error)]
}
```

Miss the comfort and safety of exceptions? No problem!

``` objc
[obj initWithData:nil error:ERR_THROW()]
```

### /rakelib/\*rake
Some useful rake targets for iOS projects...

## License
See `LICENSE`.

