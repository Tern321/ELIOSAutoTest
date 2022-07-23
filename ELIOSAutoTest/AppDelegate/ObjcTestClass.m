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

//@interface ObjcTestClass
//
//@end

@class MPVolumeView;


@implementation ObjcTestClass
 

- (void)start:(id)obj {
    NSLog(@"Static method in ObjectiveC");
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

@end
