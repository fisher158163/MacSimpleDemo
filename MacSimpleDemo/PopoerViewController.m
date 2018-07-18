//
//  PopoerViewController.m
//  WindowTest
//
//  Created by liyu on 2018/7/16.
//  Copyright © 2018年 liyu. All rights reserved.
//

#import "PopoerViewController.h"
// 选择照片、相机拍照
#import <Quartz/Quartz.h>
// 事件库框架
#import <EventKit/EventKit.h>

@interface PopoerViewController ()<NSUserNotificationCenterDelegate>
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSImageView *pictureImageView;
@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSTextField *pasteLabel;
@property (weak) IBOutlet NSView *pickerBgView;
@property (weak) IBOutlet NSDatePicker *datePicker1;
@property (weak) IBOutlet NSDatePicker *datePicker2;
@property (weak) IBOutlet NSTextField *dateLabel;
@property (nonatomic, strong) NSFont *font;
@end

@implementation PopoerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.pickerBgView.wantsLayer = YES;
    self.pickerBgView.layer.backgroundColor = [NSColor cyanColor].CGColor;
    [self setupImageView];
    [self setupDatePicker];
}

- (void)setupDatePicker {
     // 初始化选中当前日期
    [self.datePicker1 setDateValue:[NSDate date]];
    [self.datePicker1 setAction:@selector(updateDateResult:)];
    [self.datePicker2 setDateValue:[NSDate date]];
    [self.datePicker2 setAction:@selector(updateDateResult:)];
}

- (void)setupImageView {
    self.imageView.imageFrameStyle = NSImageFramePhoto; // 图片边框的样式
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = [NSColor cyanColor].CGColor;
    self.imageView.image = [NSImage imageNamed:@"dog"];
    self.imageView.imageScaling = NSImageScaleAxesIndependently;
    [self.imageView setAnimates:YES];
    self.imageView.imageAlignment = NSImageAlignTopRight; // 图片内容对于控件的位置
    [self.imageView setEditable:YES]; // 用户能否直接将图片拖到一个NSImageView类里
    [self.imageView setAllowsCutCopyPaste:YES]; // 表示用户能否对图片内容进行剪切、复制、粘贴行操作
    self.imageView.wantsLayer = YES;
    self.imageView.layer.cornerRadius = 75;
}

// 获取照片
- (IBAction)takePicture:(NSButton *)sender {
    [[IKPictureTaker pictureTaker] beginPictureTakerWithDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)pictureTakerDidEnd:(IKPictureTaker *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSImage *image = [sheet outputImage];
    if(image !=nil && (returnCode == NSModalResponseOK) ) {
        self.pictureImageView.image = image;
    }
}

// 打开字体选择面板
- (IBAction)selectFont:(NSButton *)sender {
    [self openFontPanel];
}

- (void)openFontPanel {
    // 初始化
    self.font = [NSFont systemFontOfSize:14];
    // 不需要使用代理 NSFontManagerDelegate，代理也没有方法
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setSelectedFont:[NSFont systemFontOfSize:24] isMultiple:NO];
    [fontManager setTarget:self];
    [fontManager setAction:@selector(changeFont:)];
    [fontManager orderFrontFontPanel:self];
}

- (void)changeFont:(id)sender {
    self.font = [sender convertFont:self.font];
    self.label.font = self.font;
    NSLog(@"pointSize：%f ，fontName : %@ , familyName : %@",self.font.pointSize,self.font.fontName,self.font.familyName);
}

// 打开颜色选择面板
- (IBAction)selectColor:(NSButton *)sender {
    [self openColorPanel];
}

- (void)openColorPanel {
    NSColorPanel *colorpanel = [NSColorPanel sharedColorPanel];
    colorpanel.mode = NSColorPanelModeWheel; //调出时，默认色盘
    [colorpanel setAction:@selector(changeColor:)];
    [colorpanel setTarget:self];
    [colorpanel orderFront:nil];
}

//颜色选择action事件
- (void)changeColor:(id)sender {
    NSColorPanel *colorPanel = sender ;
    NSColor *color = colorPanel.color;
    self.label.textColor = color;
}

// 发送通知
- (IBAction)sendNotification:(NSButton *)sender {
   // [self sendDefaultNotice];
      [self sendHasButtonNotice];
}

// 一般通知
- (void)sendDefaultNotice {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"这是测试title"; // 标题
    localNotify.subtitle = @"这是测试的subtitle"; // 副标题
    NSImage *image = [NSImage imageNamed:@"Mac"];
    localNotify.contentImage = image; // 显示在弹窗右边的图片
    [localNotify setValue:image forKey:@"_identityImage"]; // 显示在弹窗左边的图片logo
    localNotify.informativeText = @"如果不设置代理，通知可能发送成功并显示在通知栏，但是不会弹出。打断点的话，会弹出";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
    // 设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

// 带有按钮的通知
- (void)sendHasButtonNotice {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"这是测试title"; // 标题
    localNotify.subtitle = @"这是测试的subtitle"; // 副标题
    NSImage *image = [NSImage imageNamed:@"Mac"];
    localNotify.contentImage = image; // 显示在弹窗右边的图片
    [localNotify setValue:image forKey:@"_identityImage"]; // 显示在弹窗左边的图片logo
    localNotify.informativeText = @"http://www.zealer.com";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    // 只有当用户设置为提示模式时，才会显示按钮.不设置的话，默认为yes
    localNotify.hasActionButton = YES;
    localNotify.actionButtonTitle = @"确定";
    localNotify.otherButtonTitle = @"取消";
    [localNotify setValue:@YES forKey:@"_showsButtons"]; // 需要显示按钮
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
    // 设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    //    BOOL showAlternateActionMenu = 1; //按钮是否显示目录
    //    if (showAlternateActionMenu) {
    //        [localNotify setValue:@[@"menu1", @"menu2"] forKey:@"_alternateActionButtonTitles"];
    //        [localNotify setValue:@YES forKey:@"_alwaysShowAlternateActionMenu"];
    //    }
    //
    //    //设置回复属性
    //    localNotify.hasReplyButton = YES;
    //    localNotify.responsePlaceholder = @"回复的placeHolder";
    
    //    // 设置通知提交的时间
    //    localNotify.deliveryDate = [NSDate dateWithTimeIntervalSinceNow:2];//延时2s发送
    //
    //    //设置通知的循环(系统限制必须大于1分钟，可能是为了防止刷屏)
    //    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    //    [dateComponents setSecond:70];
    //    localNotify.deliveryRepeatInterval = dateComponents;
    
    //    [localNotify setValue:@(0) forKey:@"_lockscreenOnly"]; //是否只有锁屏状态下可见
}

//通知已经提交给通知中心
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    NSLog(@"收到通知:%@",notification);
}

//用户已经点击了通知
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    NSLog(@"用户点击");
    NSLog(@"activationType : %ld , actualDeliveryDate : %@",(long)notification.activationType,notification.actualDeliveryDate);
    //如果推送有按钮，点击按钮时，activationType 会变为 2
    if (notification.activationType == 2) {
        [self openUrlBySafariWithUrlString:notification.informativeText];
    }
}

//returen YES; 强制显示(即不管通知是否过多)
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

// 使用safari打开网页
- (void)openUrlBySafariWithUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSWorkspace sharedWorkspace] openURL: url];
}

// (日历、提醒事项)添加框架EventKit/EventKit.h>、在info.plist中添加授权描述
- (IBAction)addReminder:(NSButton *)sender {
    [self addReminderItem];
//  [self getReminders];
}

// 添加提醒事项
- (void)addReminderItem {
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        EKReminder *reminder = [EKReminder reminderWithEventStore:eventStore];
        reminder.calendar = [eventStore defaultCalendarForNewReminders];
        reminder.title = @"提醒我15分钟后喝水！";
        reminder.calendar = [eventStore defaultCalendarForNewReminders];;
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeIntervalSinceNow:20]];
        [reminder addAlarm:alarm];
        NSError *err = nil;
        [eventStore saveReminder:reminder commit:YES error:&err];
        if (error) {
            NSLog(@"error = %@",error);
        } else {
            NSLog(@"保存到提醒事项成功");
        }
    }];
}

- (void)getReminders {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSArray *reminderArray = [eventStore calendarsForEntityType:EKEntityTypeReminder];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            return ;
        }
        //获取提醒事项的分类
        for (EKCalendar *calendar in reminderArray) {
            NSLog(@"title：%@ ， type：%ld , calendarIdentifier：%@",calendar.title,(long)calendar.type,calendar.calendarIdentifier);
        }
        //来查找所有的reminders
        NSPredicate *pre =[eventStore predicateForRemindersInCalendars:@[reminderArray.firstObject]];
        //异步方法。
        [eventStore fetchRemindersMatchingPredicate:pre completion:^(NSArray<EKReminder *> * _Nullable reminders) {
            // 异步查找出提醒事项数组reminders，这里可根据需求进一步进行对数组的操作
            /*
             reminders 数组里存的是EKReminder 对象。
             列举EKReminder 的一些属性：
             title：标题
             notes：备注
             priority：优先级（NSUInteger）  0无级别，1级别高---9级别低（1-4高，5中等，6-9低）
             completed：是否已完成
             completionDate：完成时间
             alarms:提醒数组（数组里是EKAlarm对象， 可以获得跟闹钟相关的数据，如具体时间，偏移秒数...）
             */
            for (EKReminder *reminder in reminders) {
                NSLog(@"reminder - title：%@ ， notes：%@",reminder.title,reminder.notes);
            }
        }];
    }];
}

// 添加日历
- (IBAction)addCalendar:(NSButton *)sender {
    [self addCalendarItem];
}

- (void)addCalendarItem {
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = @"日历测试";
    // event.location = location;
    // [NSDate dateWithTimeIntervalSinceNow:10];
    // [NSDate dateWithTimeIntervalSinceNow:20];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:10];
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:20];
    // 设定事件开始时间
    event.startDate = startDate;
    // 设定事件结束时间
    event.endDate = endDate;
    // 添加提醒 可以添加多个，设定事件多久以前开始提醒
    // event.allDay = YES;
    // 在事件前多少秒开始事件提醒 -5.0f
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-5.f];
    [event addAlarm:alarm];
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *error;
    [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    NSLog(@"保存成功");
}

// 获取日历事件
- (void)getCalendar {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"granted：%d", granted);
        if (granted) {
            NSDate *startDate = [self dateFromString:@"2017-08"]; // 事件段，开始时间
            NSDate *endDate = [self dateFromString:@"2018-01"]; // 结束时间，取中间
            NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent *> *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
            NSArray<EKEvent *> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.subscribed;
            }]];
            NSLog(@"events:<<<<<<<<<<<< %@ >>>>>>>>>>>",events);
            for (EKEvent *event in events) {
                NSLog(@"title : %@ , startDate : %@ , endDate : %@ , calendarItemIdentifier : %@",event.title,event.startDate,event.endDate,event.calendarItemIdentifier);
            }
        }
    }];
}

- (NSDate *)dateFromString:(NSString *)dateString {
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

- (IBAction)copy:(NSButton *)sender {
    [self pasteString];
}

// 复制内容到剪贴板
- (void)pasteString {
    NSPasteboard *paste = [NSPasteboard generalPasteboard];
    [paste clearContents];
    [paste writeObjects:@[@"123456789"]];
}

- (IBAction)paste:(NSButton *)sender {
    [self getPasteString];
}

// 获得剪贴板的内容
- (void)getPasteString {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
// 粘贴板类型
/* NSPasteboardTypeString;
    NSPasteboardTypePDF;
    NSPasteboardTypeTIFF;
    NSPasteboardTypePNG;
    NSPasteboardTypeRTF;
    NSPasteboardTypeRTFD;
    NSPasteboardTypeHTML;
    NSPasteboardTypeTabularText;
    NSPasteboardTypeFont;
    NSPasteboardTypeRuler;
    NSPasteboardTypeColor;
    NSPasteboardTypeSound;
    NSPasteboardTypeMultipleTextSelection;
    NSPasteboardTypeFindPanelSearchOptions;
*/
    if ([[pasteboard types] containsObject:NSPasteboardTypeString]) {
        NSString *str = [pasteboard stringForType:NSPasteboardTypeString];
        self.pasteLabel.stringValue = str;
        NSLog(@"粘贴的文字：%@",str);
    }
}

- (void)updateDateResult:(NSDatePicker *)datePicker {
    // 拿到当前选择的日期
    NSDate *theDate = [datePicker dateValue];
    NSLog(@"日期：%@", theDate);
    if (theDate) {
        // 把选择的日期格式化成想要的形式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:theDate];
        self.dateLabel.stringValue = dateString;
        NSLog(@"日期：%@", dateString);
    }
}

- (void)dealloc {
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
}


@end
