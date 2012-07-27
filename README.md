SCNotificationCenter is a drop in class that provides a (somewhat) seamless way of using Mountain Lion's notification centre on OS 10.8 and Growl on 10.7. **This is only a temporary project**. The Growl team have [said](http://growl.posterous.com/going-forward-with-growl-and-notification-cen) that they'll be implementing support for notification centre in the next version of Growl and it'll be even more seamless than SCNotificationCenter. 

## Usage

To use, add SCNotificationCenter.h/.m & SCNotificationCenterKeys.h/.m to your project and then import SCNotifcationCenter.h into any classes you want to use it in. Then, where you create a Growl notification, simply replace `[GrowlApplicationBridge xxxx];` to `[SCNotificationCenter sharedCenter] xxxx];`. 

SCNotificationCenter includes equivalents to the following Growl methods:

`+ (void)notifyWithDictionary:(NSDictionary *)dictionary`

`+ (void)notifyWithTitle:(NSString *)title description:(NSString *)description notificationName:(NSString *)notifName iconData:(NSData *)iconData priority:(signed int)priority isSticky:(BOOL)isSticky clickContext:(id)clickContext;`

`+ (void)notifyWithTitle:(NSString *)title description:(NSString *)description notificationName:(NSString *)notifName iconData:(NSData *)iconData priority:(signed int)priority isSticky:(BOOL)isSticky clickContext:(id)clickContext identifier:(NSString *)indentifier;`

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

A simple project wide find & replace will be enough to add notification centre notifications to your project for 10.8 and maintain Growl notifications for 10.7. 

A small point, I **strongly** recommend that you don't use the notifyWithTitle: description: etc. methods but instead use `notifyWithDictionary:`. `notifyWithDictionary:` will allow you to support the extra features of notification centre notifications while maintaining backwards compatibility with Growl. 

A list of keys that can be used with the `notifyWithDictionary:` method have been provided with this project and I've tried to keep all the keys the same as the keys defined in Growl's GrowlDefines.h header, that way, if you're already using `notifyWithDictionary:` from the Growl framework, SCNotificationCenter should integrate quite nicely. 

## Limitations

- It doesn't support the full range of properties for NSUserNotifications. For example, while it's possible to create scheduled notifications with SCNotificationCenter, you can't yet setup repeating notifications. 
- It really **hasn't been tested much**.

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

The above example will produce either a Growl notification with Title "Hello World", description "This is a test of notifications on OS X" and an identifier of "not1". It will also only display if a notification with "A Notification" has been registered in the Growl notification dictionary. Alternatively, on OS 10.8, the above code will produce a notification with the same titles & description. It will also have a subtitle saying "lol" and will have an action button titled "View". Oh, and it won't be shown until 4 seconds after the method is called. 

For a real-world example, my application, [SymSteam](https://github.com/alexjohnj/symsteam) makes use of SCNotificationCenter for notifications (I originally developed the class for it) so you can check out the source code if you wish. 

## Grammar

I'm British, so calling the project SCNotificationCenter and not SCNotificationCentre was very hard, non-the-less, I've done it and it *should* be consistently named throughout the project.