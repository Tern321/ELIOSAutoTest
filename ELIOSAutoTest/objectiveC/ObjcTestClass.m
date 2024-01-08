//
//  ObjcTestClass.m
//  ELIOSAutoTest
//
//  Created by EVGENII Loshchenko on 15.07.2022.
//

#import <Foundation/Foundation.h>
#import "ObjcTestClass.h"
//#import "AVFAudio/"

#import "AVFoundation/AVFAudio.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

//@interface ObjcTestClass
//
//@end

@implementation UIWindow (swizzTest)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    printf("UIView hitTest global\n");
    // Convert the point to the target view's coordinate system.
    // The target view isn't necessarily the immediate subview
//    CGPoint pointForTargetView = [self.targetView convertPoint:point fromView:self];
//
//    if (CGRectContainsPoint(self.targetView.bounds, pointForTargetView)) {
//
//        // The target view may have its view hierarchy,
//        // so call its hitTest method to return the right hit-test view
//        return [self.targetView hitTest:pointForTargetView withEvent:event];
//    }

//    return self;
    return [super hitTest:point withEvent:event];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//    {
//        NSLog(@"hit test firing");
//       return self.view;
//    }

//-(NSNumber *)swizzle_whatAreMyTaxes {
//    float rev = [self.revenue floatValue];
//    float taxesDue = 0.21 * rev;
//    NSNumber *nsTaxesDue = [NSNumber numberWithFloat:taxesDue];
//    return nsTaxesDue;
//}

@end


@class MPVolumeView;




@implementation ObjcTestClass
 
+ (NSArray *)start:(id)obj {
    
//    m1 = class_getInstanceMethod([MyClass class], @selector(originalMethodName));
//
//    m2 = class_getInstanceMethod([MyClass class], @selector(swizzle_originalMethodName));
//
//    method_exchangeImplementations(m1, m2)
    
    
    
    
    NSLog(@"Static method in ObjectiveC");
    
    id array = [self allPropertyNames:obj];
//    NSLog(array);
    return array;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"observeValueForKeyPath2");
}

//
//public override void ObserveValue (NSString keyPath, NSObject ofObject, NSDictionary change, IntPtr context)
//    {
//                   //TODO: Filter as appropriate, error-handling, etc.
//        var volume = (float) (change ["new"] as NSNumber);
//
//        volumeLabel.Text = volume.ToString();
//    }

+ (NSArray *)allPropertyNames:(NSObject *) obj
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    NSMutableArray *rv = [NSMutableArray array];

    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }

    free(properties);

    return rv;
}

//- (void *)pointerOfIvarForPropertyNamed:(NSString *)name
//{
//    objc_property_t property = class_getProperty([self class], [name UTF8String]);
//
//    const char *attr = property_getAttributes(property);
//    const char *ivarName = strchr(attr, 'V') + 1;
//
//    Ivar ivar = object_getInstanceVariable(self, ivarName, NULL);
//
//    return (char *)self + ivar_getOffset(ivar);
//}


@end
