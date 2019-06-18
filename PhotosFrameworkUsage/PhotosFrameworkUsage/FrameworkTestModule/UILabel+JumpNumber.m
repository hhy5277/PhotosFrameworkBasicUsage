#import "UILabel+JumpNumber.h"
#import <objc/runtime.h>

#define kRangeNumberKey @"RangeKey"         //每次数字跳动相差的间隔数
#define kBeginNumberKey @"BeginNumberKey"   //起始数字
#define kEndNumberKey @"EndNumberKey"       //结束跳动时的数字
#define kFormatKey @"FormatStringKey"       //字符串格式

#define kFrequency 1.0/30.0f                //数字跳动频率
#define kRangeNumber(endNumber,duration) (endNumber * kFrequency)/duration


@interface UILabel ()

@property (nonatomic, strong) NSNumber *flickerNumber;
@property (nonatomic, strong) NSTimer *currentTimer;

@end

@implementation UILabel (JumpNumber)

#pragma mark - getter & setter methods

//No.1
//开始写代码，完成 "flickerNumber" 和 "currentTimer" 的getter、setter方法
- (void)setFlickerNumber:(NSNumber *)flickerNumber {
    objc_setAssociatedObject(self, "flickerNumber", flickerNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)flickerNumber {
    return objc_getAssociatedObject(self, "flickerNumber");
}


- (void)setCurrentTimer:(NSTimer *)currentTimer {
    objc_setAssociatedObject(self, "currentTimer", currentTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)currentTimer {
    return objc_getAssociatedObject(self, "currentTimer");
}

//end_code

#pragma mark - flicker methods(public)

- (void)oxc_setNumber:(NSNumber *)number {
    [self oxc_setNumber:number duration:1.0 format:nil];
}

- (void)oxc_setNumber:(NSNumber *)number format:(NSString *)formatStr {
    [self oxc_setNumber:number duration:1.0 format:formatStr];
}

- (void)oxc_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr{
    
    /*检查是否是数字类型*/
    if(![number isKindOfClass:[NSNumber class]]){
        self.text = [NSString stringWithFormat:@"%@",number];
        return;
    }
    
    [self.currentTimer invalidate];
    self.currentTimer = nil;
    
    /*变量初始化*/
    self.flickerNumber = @(0);
    int beginNumber = 0;
    int endNumber = [number intValue];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    if(formatStr) {
        [userInfo setObject:formatStr forKey:kFormatKey];
    }
    [userInfo setObject:@(beginNumber) forKey:kBeginNumberKey];
    [userInfo setObject:number forKey:kEndNumberKey];
    [userInfo setObject:@(kRangeNumber(endNumber, duration)) forKey:kRangeNumberKey];
    
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:kFrequency target:self selector:@selector(flickerAnimation:) userInfo:userInfo repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.currentTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - private methods
- (void)flickerAnimation:(NSTimer *)timer{
    
    //No.2
    //开始写代码，根据前后代码补全每次数字跳动的实现过程
    
    
    //获取字典信息
    NSMutableDictionary *info = timer.userInfo;
    int begin = (int)[info objectForKey:kBeginNumberKey];
    int end = ((NSNumber *)[info objectForKey:kEndNumberKey]).intValue;
    int range = ((NSNumber *)[info objectForKey:kRangeNumberKey]).intValue;
    //    NSString *format = [info objectForKey:kFormatKey];
    
    //获取text值 如果为0表示第一次；如果大于end表示到达最大值，结束定时器；否则显示当前数加上间隔数
    int value = self.text.intValue;
    //    NSLog(@"%d, %d, %d, %d", value, begin, end, range);
    
    if (value == 0) {
        self.text = [NSString stringWithFormat:@"%d", begin];
    }
    else if (value >= end) {
        self.text = [NSString stringWithFormat:@"%d", end];
        [self.currentTimer invalidate];
        self.currentTimer = nil;
        return;
    }
    else {
        value += range;
        self.text = [NSString stringWithFormat:@"%d", value];
    }
    
    
    //end_code
}

- (NSString *)finalString:(NSNumber *)number stringFormat:(NSString *)formatStr {
    NSAssert([formatStr rangeOfString:@"%@"].location != NSNotFound, @"string format type is not matched,please check your format type");
    return [NSString stringWithFormat:formatStr,number];
}

@end

