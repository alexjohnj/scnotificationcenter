SCNotificationCenter is a drop in class that provides a (somewhat) seamless way of using Mountain Lion's notification center on OS 10.8 while maintaining backwards compatibility with Growl on OS 10.7. 

## Usage

Add SCNotificationCenter.h/.m & SCNotificationCenterKeys.h/.m to your project and then import SCNotificationCenter.h into any classes you want to use it in. Then, wherever you create a Growl notification, replace `[GrowlApplicationBridge doSomething]` to `[SCNotificationCenter doSomething]`. 

SCNotificationCenter provides methods that match the name of the following Growl methods:

`+ (void)notifyWithDictionary:(NSDictionary *)dictionary`

``` 
+ (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext;
```

```
+ (void)notifyWithTitle:(NSString *)title
            description:(NSString *)description
       notificationName:(NSString *)notifName
               iconData:(NSData *)iconData
               priority:(signed int)priority
               isSticky:(BOOL)isSticky
           clickContext:(id)clickContext
             identifier:(NSString *)identifier;
```

So for most people's notifications, this:

```
[GrowlApplicationBridge notifyWithTitle:@"A notification"
                                description:@"A short description of the notification"
                           notificationName:@"aNotification"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];
```

Will become this:

```
[SCNotificationCenter notifyWithTitle:@"A notification"
                                description:@"A short description of the notification"
                           notificationName:@"aNotification"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];
```

A simple project wide find and replace should be enough to update the project to use SCNotificationCenter. The above convenience methods will be enough for most people but there's a couple of additional methods that you may find handy. To access these, just create the SCNotificationCenter singleton using `[SCNotificationCenter sharedCenter]`.

## Using NSUserNotification Features

If you use the `notifyWithDictionary:` method you can use features that NSUserNotification supports and Growl doesn't by including the appropriate keys. Any keys that Growl doesn't recognise it will ignore. At the moment, you can:

- Add action buttons & titles.
- Schedule a notification delivery date. 
- Add a notification sound.

I **strongly** recommend that you use the `notifyWithDictionary:` method as this will make it easier for you to support features available in NSUserNotification while maintaining backwards compatibility. A list of keys that can be used with the `notifyWithDictionary:` method are included in a header file.

## Overriding the Default Notification Method

If you want, you can override which notification system is used regardless of availability. This could come in handy if you wish to give your Mountain Lion users the choice between using Growl or Notification Center. To do so use the following method:

```
- (BOOL)setNotificationMethodPreference:(SCNotificationMethod)preference;
```

`SCNotificationMethod` is an `NSUInteger` between 0 & 2. 

- 0 = Notify using Notification Center.
- 1 = Notify using Growl.
- 2 = Notify by availability (default).

Calling this method will add a key to your application's user defaults called `SCNotificationMethod`. 

## Limitations

- SCNotificationCenter doesn't support the full range of properties for NSUserNotifications. For example, while it's possible to create scheduled notifications with SCNotificationCenter, you can't yet setup repeating notifications. 
- SCNotificationCenter really **hasn't been tested much**.

## Examples

Just some quick examples. The not recommended way of making notifications:

```
[SCNotificationCenter notifyWithTitle:@"Hello World"
                          description:@"Testing"
                     notificationName:@"A Notification"
                             iconData:nil
                             priority:0
                             isSticky:NO
                         clickContext:@"Hello World"];
```

The recommended way:

```
[SCNotificationCenter sharedCenter notifyWithDictionary:@{
                    SCNotificationCenterNotificationName : @"A Notification",
                   SCNotificationCenterNotificationTitle : @"Hello World",
                SCNotificationCenterNotificationSubtitle : @"Lol",
             SCNotificationCenterNotificationDescription : @"This is a test of notifications on OS X",
            SCNotificationCenterNotificationDeliveryDate : [NSDate dateWithTimeInterval:4 sinceDate:[NSDate date]],
         SCNotificationCenterNotificationHasActionButton : @YES,
       SCNotificationCenterNotificationActionButtonTitle : @"View",
              SCNotificationCenterNotificationIdentifier : @"not1"
}];
```

For a real-world example, my application [SymSteam](https://github.com/alexjohnj/symsteam) makes use of SCNotificationCenter for notifications (I originally developed the class for it) so you can check out the source code if you wish.

## Grammar

I'm British, so calling the project SCNotificationCenter and not SCNotificationCentre was very hard, non-the-less, I've done it and it *should* be consistently named throughout the project.

## License

Licensed under the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/). Basically, you're free to use this class how you wish just leave credit where it's due. 