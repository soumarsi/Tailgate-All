//
//  TGselectVenueViewController.h
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 25/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TGGlobalClass.h"
#import "TGGlobal.h"

#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"

@interface TGselectVenueViewController : UIViewController<CLLocationManagerDelegate,TGGlobal,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *venuePicker;
@property (strong, nonatomic)TGGlobalClass *GlobalClass;
@property (nonatomic,retain) NSMutableArray *venueArray;
@property (nonatomic, strong)NSMutableArray *locationData;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)NSMutableDictionary *locationdict;
@property (nonatomic, strong)NSString *venueString;
@property (nonatomic, strong)NSString *locId;
@property (nonatomic)float latitude;
@property (nonatomic)float longitude;
@property (nonatomic, strong)NSString *type;
@property (nonatomic) int data;
@property (nonatomic, strong)UIActionSheet *settingsPopUp;
- (IBAction)venueSelectButton:(id)sender;
- (IBAction)settingsButton:(UIButton *)sender;

@end
