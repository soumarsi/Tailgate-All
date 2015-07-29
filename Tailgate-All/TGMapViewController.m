//
//  TGMapViewController.m
//  Taligate
//
//  Created by Soumarsi Kundu on 27/03/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGMapViewController.h"
#import "TGMapEdit.h"
#import "TGBecons.h"
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GMDraggableMarkerManager.h"
#import "TGGlobalClass.h"
#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"
#import "TGMapSave.h"
#import "RTCanvas.h"
#import "TGMapSaveiphone.h"
#import "TGLoginViewController.h"
#import "TGMapoxfordedit.h"
#ifdef DEBUG

#define DebugLog(...) NSLog(__VA_ARGS__)

#else

#define DebugLog(...) while(0)

#endif

@interface TGMapViewController ()<TGBecons,MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GMDraggableMarkerManagerDelegate,GMSMapViewDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    TGMapEdit *EditView;
    TGMapoxfordedit *editoxfordmapView;
    NSMutableArray *DataArray;
    NSMutableArray *preDataArray;
    NSMutableArray *savedLocationArray;
    TGBecons *BeconsView;
    TGBecons *SelectedBecons;
    UIView *EditorVIEW;
    UIView *mainView;
    RTCanvas *editorArea;
    UIImage *img;
    MKMapView *Map;
    CLLocationManager *locationManager;
    CGPoint touchCoordinate;
    UITextField *SearchTextfield;
    UIButton *checkbox;
    GMSMapView *mapView_;
    NSOperationQueue *downloadQueue;
    GMDraggableMarkerManager *draggableMarkerManager;
    TGGlobalClass *globalClass;
    NSString *packageID;
    int buttonCounter;
    BOOL blankCheck;
    UIActivityIndicatorView *activityIndi;
    TGMapSave *MapSave;
    TGMapSaveiphone *mapSaveIphone;
    GMSMarker *markerpoint;
}
@property (weak, nonatomic, readwrite) id<GMDraggableMarkerManagerDelegate> dragdelegate;
@property (weak, nonatomic) id<TGGlobal>editdelegate;
@end

@implementation TGMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    device = [[UIDevice alloc]init];
    
    buttonCounter = 0;

  check_box_number=-1;
    DebugLog(@"self---- %f------ %f",self.view.frame.size.width,self.view.frame.size.height);
    
    globalClass = [[TGGlobalClass alloc]init];
    
    downloadQueue = [[NSOperationQueue alloc]init];
    searchresult = [[NSMutableArray alloc]init];
    
    DataArray = [[NSMutableArray alloc]init];
    SavedDataArray = [[NSMutableArray alloc]init];
    preDataArray = [[NSMutableArray alloc]init];
    locationDataArray = [[NSMutableArray alloc]init];
    savedLocationArray = [[NSMutableArray alloc]init];
    
    //Backgroundview allocation//====
    
    BackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [BackGroundView setBackgroundColor:[UIColor LabelWhiteColor]];
    [self.view addSubview:BackGroundView];
    
    //Headerview====
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 70)];
    [HeaderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage HeaderTopImage]]];
    [BackGroundView addSubview:HeaderView];
    
    
    UIButton *SearchButton = [[UIButton alloc]initWithFrame:CGRectMake(430.0f, 25, 100, 30)];
    [SearchButton setBackgroundColor:[UIColor blueColor]];
    [SearchButton setTitle:@"Search" forState:UIControlStateNormal];
    SearchButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [SearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SearchButton addTarget:self action:@selector(Search:) forControlEvents:UIControlEventTouchUpInside];
    
//    ----------Already Saved Data--------
    
    [self firstdata];
    
    
    //------
    //searchtextfield-----
    
    SearchTextfield = [[UITextField alloc]initWithFrame:CGRectMake(40.0f, 25, 350, 30)];
    [SearchTextfield setBackgroundColor:[UIColor clearColor]];
    [SearchTextfield setTextAlignment:NSTextAlignmentLeft];
    [SearchTextfield setTextColor:[UIColor blackColor]];
    //[SearchTextfield setFont:[UIFont fontWithName:GLOBALTEXTFONT size:16]];
    [SearchTextfield setDelegate:self];
    SearchTextfield.autocorrectionType = NO;
    SearchTextfield.autocorrectionType = NO;
    SearchTextfield.layer.borderWidth = 1.0f;
    SearchTextfield.layer.borderColor = [[UIColor blackColor]CGColor];
    SearchTextfield.layer.cornerRadius = 5.0f;
    //[HeaderView addSubview:SearchTextfield];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_LocationLattitude
                                                            longitude:_LocationLongitude
                                                                 zoom:16];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    mapView_.myLocationEnabled = NO;
    mapView_.delegate = self;
    [BackGroundView addSubview: mapView_];
    mapView_.userInteractionEnabled = YES;
    
    
    
    
    ///Header line-=====
    

    
//    ---------------Location Data Tableview------------
    //

    
    //HeaderLabel--=======
    
    HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30.0f,self.view.frame.size.width, 25)];
    [HeaderLabel setBackgroundColor:[UIColor clearColor]];
    [HeaderLabel setText:_VenueName];
    [HeaderLabel setTextAlignment:NSTextAlignmentCenter];
    [HeaderLabel setTextColor:[UIColor whiteColor]];
    [HeaderLabel setFont:[UIFont MapViewHeaderLabel]];
    [HeaderView addSubview:HeaderLabel];
    
    //BackButton=========
    
    BackButton = [[UIButton alloc]init];
    [BackButton setBackgroundImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [BackButton addTarget:self action:@selector(BackButton:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderView addSubview:BackButton];
    
    
    //Settings image--======
    
    SettingsImage = [[UIImageView alloc]init];
    [SettingsImage setImage:[UIImage imageNamed:@"settings"]];
   // [HeaderView addSubview:SettingsImage];
    
    
    
    UIButton *settingsButton = [[UIButton alloc]init];
    [settingsButton setBackgroundColor:[UIColor ClearColor]];
   // [settingsButton addTarget:self action:@selector(Settings:) forControlEvents:UIControlEventTouchUpInside];
    //[HeaderView addSubview:settingsButton];
    
    DebugLog(@"LATITUDE----------> %f",self.LocationLattitude);
    DebugLog(@"LONGITUDE------> %f",self.LocationLongitude);
    
    
    
    PickerBckView  = [[UIView alloc]init];
    [PickerBckView setBackgroundColor:[UIColor whiteColor]];
    [PickerBckView setAlpha:1.0f];
    [self.view addSubview:PickerBckView];
    [PickerBckView setHidden:YES];
    
    DataPickerView = [[UIPickerView alloc] init];
    DataPickerView.layer.zPosition=9;
    DataPickerView.backgroundColor=[UIColor clearColor];
    DataPickerView.dataSource = self;
    DataPickerView.delegate = self;
    DataPickerView.tag = 1;
    DataPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:DataPickerView];
    [DataPickerView setHidden:YES];
    
    
    
    
    //this is only for type of oxford:
    
    oxfordPicker = [[UIPickerView alloc] init];
    oxfordPicker.layer.zPosition=9;
    oxfordPicker.backgroundColor=[UIColor clearColor];
    oxfordPicker.dataSource = self;
    oxfordPicker.delegate = self;
    oxfordPicker.tag = 3;
    oxfordPicker.showsSelectionIndicator = YES;
    [self.view addSubview:oxfordPicker];
    [oxfordPicker setHidden:YES];
    


    DoneButton = [[UIButton alloc]init];
    [DoneButton setBackgroundColor:[UIColor clearColor]];
    [DoneButton setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [DoneButton addTarget:self action:@selector(Done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DoneButton];
    [DoneButton setHidden:YES];
    
    CancelButton = [[UIButton alloc]init];
    [CancelButton setBackgroundColor:[UIColor clearColor]];
    [CancelButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [CancelButton addTarget:self action:@selector(CancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CancelButton];
    [CancelButton setHidden:YES];

    
    

    //becons image--=====
    
    BeconsView = [[TGBecons alloc]init];
    BeconsView.TgDelegate = self;
    [BeconsView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Becons"]]];
    [BeconsView configure];
    [BackGroundView addSubview:BeconsView];
    
    DisableView = [[UIView alloc]init];
    [DisableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:DisableView];
    [DisableView setHidden:YES];
    
    
    if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
    {
        BackButton.frame = CGRectMake(15, 28, 28, 28);
        SettingsImage.frame = CGRectMake(self.view.frame.size.width-43-8, 28, 28, 28);
        settingsButton.frame = CGRectMake(self.view.frame.size.width-43-8, 28, 28, 28);
        BeconsView.frame = CGRectMake(self.view.frame.size.width-105, 23, 40, 40);
        DisableView.frame = CGRectMake(self.view.frame.size.width-105, 20.0f, 140.0f, 50.0f);
        PickerBckView.frame = CGRectMake(0.0f, self.view.frame.size.height-200, self.view.frame.size.width, 200);
        DataPickerView.frame = CGRectMake(0.0f, self.view.frame.size.height-150, self.view.frame.size.width, 200);
        oxfordPicker.frame = CGRectMake(0.0f, self.view.frame.size.height-150, self.view.frame.size.width, 200);
        DoneButton.frame = CGRectMake(self.view.frame.size.width-190, self.view.frame.size.height-190, 83, 35);;
        CancelButton.frame = CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-190, 83, 35);;
    }
    else
    {
        BackButton.frame = CGRectMake(30, 28, 28, 28);
        SettingsImage.frame = CGRectMake(953, 28, 28, 28);
        settingsButton.frame = CGRectMake(953, 28, 28, 28);
        BeconsView.frame = CGRectMake(865, 23, 40, 40);
        DisableView.frame = CGRectMake(865.0f, 20.0f, 180.0f, 50.0f);
        PickerBckView.frame = CGRectMake(0.0f,600.0f, self.view.frame.size.width, self.view.frame.size.height-500.0f);
        DataPickerView.frame = CGRectMake(0,600, self.view.frame.size.width, self.view.frame.size.height-530.0f);
        oxfordPicker.frame = CGRectMake(0,600, self.view.frame.size.width, self.view.frame.size.height-530.0f);
        DoneButton.frame = CGRectMake(900, 610, 83, 35);
        CancelButton.frame = CGRectMake(800, 610, 83, 35);
    }
    // Do any additional setup after loading the view.
    
    
}

-(void)firstdata
{
    if (globalClass.connectedToNetwork == YES) {
        
        [SavedDataArray removeAllObjects];
        
        [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=orderList&located=true&locationId=%@",self.locationId] Withblock:^(id result, NSError *error) {
            
            DebugLog(@"SAVED DATA RETURN DATA--------->%@",result);
            
            
            if ([[result objectForKey:@"message"] isEqualToString:[NSString Norecordfound] ]) {
                
                DebugLog(@"NO RECORD FOUND");
                
            }else{
                
                preDataArray = [result objectForKey:@"orderdata"];
                
                DebugLog(@"pREdATAaRRAY--------->%lu",(unsigned long)preDataArray.count);
                
                for (data = 0; data < preDataArray.count; data ++)
                {
                    preSavedDict = [[NSMutableDictionary alloc]init];
                    
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"event_date"] forKey:@"event_date"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data] objectForKey:@"lat"] forKey:@"lat"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data] objectForKey:@"long"] forKey:@"long"];
                    [preSavedDict setObject:[NSString stringWithFormat:@"%d",data] forKey:@"tag"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data] objectForKey:@"order_id"] forKey:@"order_id"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data] objectForKey:@"package_id"] forKey:@"package_id"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data] objectForKey:@"first_name"] forKey:@"firstname"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data] objectForKey:@"last_name"] forKey:@"lastname"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"package_name"] forKey:@"package_name"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"placeid"] forKey:@"placeid"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"pktyid"] forKey:@"pktyid"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"distanceid"] forKey:@"distanceid"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"colorid"] forKey:@"colorid"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"roadid"] forKey:@"roadid"];
                    [preSavedDict setObject:[[preDataArray objectAtIndex:data]objectForKey:@"event_name"] forKey:@"event_name"];
                    
                    [SavedDataArray addObject:preSavedDict];
                }
                
                [self applymapview];
                
                
            }
            
        }];
    }

}

-(void)applymapview
{
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    
    [SelectedBecons removeFromSuperview];
 
    draggableMarkerManager = [[GMDraggableMarkerManager alloc] initWithMapView:mapView_ delegate:self];

    markerpoint.map = nil;
    [mapView_ clear];
    DebugLog(@"savetablearray--------- > : %@", SavedDataArray);
    
    for (int k = 0; k< SavedDataArray.count; k++)
    {
        sampleMarkerLocations = [[NSMutableArray alloc] initWithObjects:[[CLLocation alloc] initWithLatitude:[[NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"lat"]]floatValue ] longitude:[[NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"long"]]floatValue ]],nil];
        DebugLog(@"samplemarkerlocation-------- %@", sampleMarkerLocations);
        
        for (CLLocation *sampleMarkerLocation in sampleMarkerLocations)
        {
            markerpoint = [GMSMarker markerWithPosition:sampleMarkerLocation.coordinate];
            markerpoint.userData = [NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"tag"]];
            
            switch (k) {
                    
                default:
                    [draggableMarkerManager addDraggableMarker:markerpoint];
                    break;
            }
            
            markerpoint.map = mapView_;
        }
    }
    DebugLog(@"MAP PIN COORDINATE--------> %@",sampleMarkerLocations);
    
}

-(void)Submit:(UIButton *)sender
{
    
    if([self.Type isEqualToString:@"Oxford"])
    {
        if ([EditView.ButtonLabel.text isEqualToString:@"Select the order from list"])
        {
            
        }
        else
        {
                [DisableView setHidden:YES];
                
                UIView *screenshotview = [[UIView alloc]initWithFrame:CGRectMake(1025, 72.0f, 1024,698)];
                [screenshotview setBackgroundColor:[UIColor clearColor]];
                [BackGroundView addSubview:screenshotview];
                
                
                NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&zoom=%d&size=1024x698&sensor=true",[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"]]floatValue],[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"]]floatValue],zoommap];
                
                
                
                NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
                
                MapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, 1024, 698)];
                [MapView setImage:image];
                [screenshotview addSubview:MapView];
                
                
                UIImageView *backview = [[UIImageView alloc]initWithFrame:CGRectMake(315.0f, 102.0f, 387.5f, 237.5f)];
                [backview setImage:[UIImage imageNamed:@"mappopupdown"]];
                [screenshotview addSubview:backview];
                
                
                UILabel *ButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0f,23.0f, 340.0f, 45.0f)];
                [ButtonLabel setBackgroundColor:[UIColor clearColor]];
                [ButtonLabel setText:[NSString stringWithFormat:@"%@",EditView.ButtonLabel.text]];
                [ButtonLabel setTextAlignment:NSTextAlignmentLeft];
                [ButtonLabel setTextColor:[UIColor BlackColor]];
                [ButtonLabel setFont:[UIFont ButtonLabel]];
                [backview addSubview:ButtonLabel];
                
                UITextView *_DescriptionText = [[UITextView alloc]initWithFrame:CGRectMake(25,75,340,120)];
                _DescriptionText.font = [UIFont ButtonLabel];
                _DescriptionText.backgroundColor = [UIColor clearColor];
                _DescriptionText.textColor = [UIColor BlackColor];
                _DescriptionText.scrollEnabled = YES;
                _DescriptionText.pagingEnabled = YES;
                _DescriptionText.editable = NO;
                _DescriptionText.delegate = self;
                _DescriptionText.text = [NSString stringWithFormat:@"%@",self.packegeNameString];
                _DescriptionText.layer.borderWidth = 1.5f;
                _DescriptionText.layer.borderColor = [[UIColor colorWithRed:(179.0f/255.0f) green:(179.0f/255.0f) blue:(179.0f/255.0f) alpha:1] CGColor];
                _DescriptionText.textAlignment = NSTextAlignmentLeft;
                _DescriptionText.layer.cornerRadius = 3.0f;
                [_DescriptionText setAutocorrectionType:UITextAutocorrectionTypeNo];
                [backview addSubview:_DescriptionText];
                
                [self imageWithView:screenshotview];
          
                
                [SelectedBecons setButtonLabel:[NSString stringWithFormat:@"%@",EditView.ButtonLabel.text]];
                [SelectedBecons setDescriptionText:[NSString stringWithFormat:@"%@",EditView.DescriptionText.text]];
                
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"]],@"lat",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"]],@"long", nil];
                
                [SavedDataArray addObject:dict];

        
        if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
        {
            mapSaveIphone = [[TGMapSaveiphone alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:mapSaveIphone];
        }
        else
        {
            MapSave = [[TGMapSave alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:MapSave];
        }
    
    //////////////-================AfterSavePickerView==========///////////////
        
        AfterSavePickerView  = [[UIView alloc]init];
        [AfterSavePickerView setBackgroundColor:[UIColor whiteColor]];
        [AfterSavePickerView setAlpha:1.0f];
        [self.view addSubview:AfterSavePickerView];
        [AfterSavePickerView setHidden:YES];
        
        PopupPicker = [[UIPickerView alloc] init];
        PopupPicker.layer.zPosition=9;
        PopupPicker.backgroundColor=[UIColor clearColor];
        PopupPicker.dataSource = self;
        PopupPicker.delegate = self;
        PopupPicker.tag = 2;
        PopupPicker.showsSelectionIndicator = YES;
        [self.view addSubview:PopupPicker];
        [PopupPicker setHidden:YES];
        
        PopupDoneButton = [[UIButton alloc]init];
        [PopupDoneButton setBackgroundColor:[UIColor clearColor]];
        [PopupDoneButton setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        [PopupDoneButton addTarget:self action:@selector(PickerDone:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PopupDoneButton];
        [PopupDoneButton setHidden:YES];
        
        PopupCancelButton = [[UIButton alloc]init];
        [PopupCancelButton setBackgroundColor:[UIColor clearColor]];
        [PopupCancelButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [PopupCancelButton addTarget:self action:@selector(PickerCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PopupCancelButton];
        [PopupCancelButton setHidden:YES];
        
        if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
        {
            AfterSavePickerView.frame = CGRectMake(0.0f,self.view.frame.size.height-210, self.view.frame.size.width, 210.0f);
            PopupPicker.frame = CGRectMake(0,self.view.frame.size.height-170, self.view.frame.size.width, 180.0f);
            PopupDoneButton.frame = CGRectMake(self.view.frame.size.width-190, self.view.frame.size.height-205, 83, 35);
            PopupCancelButton.frame = CGRectMake( self.view.frame.size.width-100, self.view.frame.size.height-205, 83, 35);
        }
       
        else
        {
            AfterSavePickerView.frame = CGRectMake(0.0f,600.0f, self.view.frame.size.width, self.view.frame.size.height-500.0f);
            PopupPicker.frame = CGRectMake(0,600, self.view.frame.size.width, self.view.frame.size.height-530.0f);
            PopupDoneButton.frame = CGRectMake(900, 610, 83, 35);
            PopupCancelButton.frame = CGRectMake(800, 610, 83, 35);
        }
    

    
    if ([self.Type isEqualToString:@"Oxford"])
    {
        Typecheck = 2;
    }
    else
    {
        Typecheck = 1;
    }
    
    [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=placeInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
    {
        if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
        {
            self.PlaceaArray = [result objectForKey:@"placeinfodata"];
            
        }
        else
        {
   
            
        }
            [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=packagetypeInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
             {
                 if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                 {
                      self.PackageArray = [result objectForKey:@"packagetypedata"];
                 }
                 else{
           
                     
                 }
                     [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=distanceInfo"] Withblock:^(id result, NSError *error)
                      {
                          if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                          {
                          self.DistanceArray = [result objectForKey:@"distancedata"];
                          }
                          else
                          {
                   
                          }
                              [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=roadInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
                               {
                                   if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                                   {
                                       self.RoadArray = [result objectForKey:@"roaddata"];
                                   }
                                   else{
                        
                                       
                                    }
                                       [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=colorInfo"] Withblock:^(id result, NSError *error) {
                                           if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                                           {
                                           
                                           self.ColorArray = [result objectForKey:@"colordata"];
                                           }
                                           else
                                           {
                             
                                           }
                                       }];

                                 
                               }];

                        
                      }];

                
             }];

      
    }];
        }

    }
    else
    {
    if ([EditView.ButtonLabel.text isEqualToString:@"Select the order from list"])
    {
         DebugLog(@"asche");
    }
    else
    {
        
  
            
            [DisableView setHidden:YES];
            
            UIView *screenshotview = [[UIView alloc]initWithFrame:CGRectMake(1025, 72.0f, 1024, 698)];
            [screenshotview setBackgroundColor:[UIColor clearColor]];
            [BackGroundView addSubview:screenshotview];
            
            
            NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&zoom=%d&size=1024x698&sensor=true",[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"]]floatValue],[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"]]floatValue],zoommap];
            
        
            
            NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
            
            MapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, 1024, 698)];
            [MapView setImage:image];
            [screenshotview addSubview:MapView];
            
            
            UIImageView *backview = [[UIImageView alloc]initWithFrame:CGRectMake(315.0f, 102.0f, 387.5f, 237.5f)];
            [backview setImage:[UIImage imageNamed:@"mappopupdown"]];
            [screenshotview addSubview:backview];
            
            
            UILabel *ButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0f,23.0f, 340.0f, 45.0f)];
            [ButtonLabel setBackgroundColor:[UIColor clearColor]];
            [ButtonLabel setText:[NSString stringWithFormat:@"%@",EditView.ButtonLabel.text]];
            [ButtonLabel setTextAlignment:NSTextAlignmentLeft];
            [ButtonLabel setTextColor:[UIColor BlackColor]];
            [ButtonLabel setFont:[UIFont ButtonLabel]];
            [backview addSubview:ButtonLabel];
            
            UITextView *_DescriptionText = [[UITextView alloc]initWithFrame:CGRectMake(25,75,340,120)];
            _DescriptionText.font = [UIFont ButtonLabel];
            _DescriptionText.backgroundColor = [UIColor clearColor];
            _DescriptionText.textColor = [UIColor BlackColor];
            _DescriptionText.scrollEnabled = YES;
            _DescriptionText.pagingEnabled = YES;
            _DescriptionText.editable = NO;
            _DescriptionText.delegate = self;
            _DescriptionText.text = [NSString stringWithFormat:@"%@",self.packegeNameString];
            _DescriptionText.layer.borderWidth = 1.5f;
            _DescriptionText.layer.borderColor = [[UIColor colorWithRed:(179.0f/255.0f) green:(179.0f/255.0f) blue:(179.0f/255.0f) alpha:1] CGColor];
            _DescriptionText.textAlignment = NSTextAlignmentLeft;
            _DescriptionText.layer.cornerRadius = 3.0f;
            [_DescriptionText setAutocorrectionType:UITextAutocorrectionTypeNo];
            [backview addSubview:_DescriptionText];
            
            [self imageWithView:screenshotview];
            
            
            [SelectedBecons setButtonLabel:[NSString stringWithFormat:@"%@",EditView.ButtonLabel.text]];
            [SelectedBecons setDescriptionText:[NSString stringWithFormat:@"%@",EditView.DescriptionText.text]];
            
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"]],@"lat",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"]],@"long", nil];
            
            [SavedDataArray addObject:dict];
            
            [SelectedBecons removeFromSuperview];
            
            [self applymapview];
            
            [EditView setHidden:YES];
            
            [self finalURLFire];    //-----------Final URL FUNCTION-----------
            
        }
    }
}

-(void)CanCel:(UIButton *)sender
{
   [self firstdata];
    
   
    
    [EditView setHidden:YES];
    [SelectedBecons setHidden:YES];
    [PickerBckView setHidden:YES];
    [DataPickerView setHidden:YES];
    [DoneButton setHidden:YES];
    [CancelButton setHidden:YES];
    [DisableView setHidden:YES];
 }
-(void)checkbox:(UIButton *)sender{
    
    DebugLog(@"CHECK BOX TAPPED");
    
    if ([checkbox.currentImage isEqual:[UIImage imageNamed:@"uncheck"]]) {
        
        
        [checkbox setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
    }else{
        
        [checkbox setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    
}
-(void)DropDown:(UIButton *)sender
{
    DebugLog(@"DropDown TAPPED=======");
    
    if (blankCheck == YES) {
        
        DebugLog(@"DATA ARRAY BLANK");
        
        UIAlertView *alertBlank = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No record found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertBlank show];
        
    }else{
        
        DebugLog(@"Dataarray------ %@", DataArray);
        
        
        [PickerBckView setHidden:NO];
        [DataPickerView setHidden:NO];
        [DoneButton setHidden:NO];
        [CancelButton setHidden:NO];
        
        [DataPickerView selectRow:0 inComponent:0 animated:NO];
        DataString = [NSString stringWithFormat:@"%@ %@  %@",[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"first_name"],[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"last_name"],[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"event_date"]];
        orderID = [[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"order_id"];
        
    }
}

//uipickerview delegate method///----------

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (pickerView.tag == 2)
    {
        UILabel *retval = (id)view;
        if (!retval) {
            retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] ;
        }
        
        
        retval.font = [UIFont PickerLabel];
        retval.textAlignment= NSTextAlignmentCenter;
        retval.textColor = [UIColor blackColor];
        retval.text = [NSString stringWithFormat:@"%@",[[self.GlobalPickerArray objectAtIndex:row] objectForKey:@"name"]];
        return retval;

    }
    else if (pickerView.tag == 3)
    {
        UILabel *retval = (id)view;
        if (!retval) {
            retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] ;
        }
        
        DebugLog(@"DATAARRAY----IN PICKER VIEW FOR ROW----------->%lu",(unsigned long)DataArray.count);
        
        retval.font = [UIFont PickerLabel];
        retval.textAlignment= NSTextAlignmentCenter;
        retval.textColor = [UIColor blackColor];
        retval.text = [NSString stringWithFormat:@"%@  %@",[[self.orderArrayDropdown objectAtIndex:row] objectForKey:@"event_name"],[[self.orderArrayDropdown objectAtIndex:row] objectForKey:@"event_date"]];
        return retval;

    }
    else
    {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] ;
    }
    
    DebugLog(@"DATAARRAY----IN PICKER VIEW FOR ROW----------->%lu",(unsigned long)DataArray.count);
    
    retval.font = [UIFont PickerLabel];
    retval.textAlignment= NSTextAlignmentCenter;
    retval.textColor = [UIColor blackColor];
        if ([self.Type isEqualToString:@"Oxford"])
        {
           retval.text = [NSString stringWithFormat:@"%@ %@",[[DataArray objectAtIndex:row] objectForKey:@"first_name"],[[DataArray objectAtIndex:row] objectForKey:@"last_name"]];
        }
        else
        {
    retval.text = [NSString stringWithFormat:@"%@ %@  %@",[[DataArray objectAtIndex:row] objectForKey:@"first_name"],[[DataArray objectAtIndex:row] objectForKey:@"last_name"],[[DataArray objectAtIndex:row] objectForKey:@"event_date"]];
        }
    return retval;
    }
    return nil;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0f;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 2)
    {
        return self.GlobalPickerArray.count;
    }
    else if (pickerView.tag == 3)
    {
        return self.orderArrayDropdown.count;
    }
    else{
    return DataArray.count;
    }
    return 0;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 2)
    {
        if ([CheckString isEqualToString:@"Place"])
        {
            savepickerName = [NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"name"]];
            self.savePlaceId = [NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"id"]];

        }
        else if ([CheckString isEqualToString:@"package"])
        {
            savepickerName = [NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"name"]];

              self.savePackegeId = [NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"id"]];
        }
        else if ([CheckString isEqualToString:@"Distance"])
        {
            savepickerName = [NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"name"]];
            self.saveDistanceId = [NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"id"]];

        }
        else if ([CheckString isEqualToString:@"Road"])
        {
            savepickerName = [NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"name"]];
            self.saveRoadId = [NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"id"]];

        }
        else if ([CheckString isEqualToString:@"color"])
        {
            savepickerName = [NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"name"]];
            self.saveColorId = [NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:[PopupPicker selectedRowInComponent:component]] objectForKey:@"id"]];


        }
             }
    else if (pickerView.tag == 3)
    {
        DataString = [NSString stringWithFormat:@"%@  %@",[[self.orderArrayDropdown objectAtIndex:[oxfordPicker selectedRowInComponent:component]] objectForKey:@"event_name"],[[self.orderArrayDropdown objectAtIndex:[oxfordPicker selectedRowInComponent:component]] objectForKey:@"event_date"]];
        
        orderID = [[self.orderArrayDropdown objectAtIndex:[oxfordPicker selectedRowInComponent:component]] objectForKey:@"event_id"];
    }
    else{
        
        if ([self.Type isEqualToString:@"Oxford"])
        {
            DataString = [NSString stringWithFormat:@"%@ %@",[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:component]] objectForKey:@"first_name"],[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:component]] objectForKey:@"last_name"]];
        }else{
        
            DataString = [NSString stringWithFormat:@"%@ %@  %@",[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:component]] objectForKey:@"first_name"],[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:component]] objectForKey:@"last_name"],[[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:component]] objectForKey:@"event_date"]];
            
            orderID = [[DataArray objectAtIndex:[DataPickerView selectedRowInComponent:component]] objectForKey:@"order_id"]; //-----------Required Final PK

        }
    
    DebugLog(@"ORDER ID---------> %@",orderID);
    }
}

///---------///---------//------
-(void)Done:(UIButton *)sender
{
    NSLog(@"asche oxford");
    
    if ([self.Type isEqualToString:@"Oxford"])
    {
        if ([chekoxford isEqualToString:@"order"])
        {
            [PickerBckView setHidden:YES];
            [DataPickerView setHidden:YES];
            [DoneButton setHidden:YES];
            [CancelButton setHidden:YES];
            editoxfordmapView.orderButtonLabel.text = [NSString stringWithFormat:@"%@",DataString];
            
            activityIndi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndi.backgroundColor=[UIColor clearColor];
            activityIndi.hidesWhenStopped = YES;
            activityIndi.frame=CGRectMake(160.0f,90.0f,50.0f,50.0f);
            activityIndi.userInteractionEnabled=YES;
            //                activityCheck = YES;
            [activityIndi startAnimating];
            [EditView addSubview: activityIndi];
            
            //    ---------------------For Order List-----------------
            
            if (globalClass.connectedToNetwork == YES ) {
                
                
                [globalClass GlobalStringDict:[NSString stringWithFormat:@"action.php?mode=oxfordOrderList&event_id=%@&buyer_id=%@",eventID,buyerID] Globalstr:@"" Withblock:^(id result, NSError *error) {
                    
                    DebugLog(@"location DATA RETURN DATA--------->%@",result);
                    
                    if ([[result objectForKey:@"message"] isEqualToString:[NSString Noorderfound] ]|| [[result objectForKey:@"locationdata"] isKindOfClass:[NSNull class]] || [result objectForKey:@"locationdata"]  == (id)[NSNull null]) {
                        
                        DebugLog(@"NO ORDER LIST FOUND");
                        
                        [activityIndi stopAnimating];
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No order found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        
                    }else{
                        
                        DebugLog(@"ESLE COMING=============>");
                        
                        [savedLocationArray removeAllObjects];
                        
                        locationDataArray = [result objectForKey:@"orderdata"];
                        for (data = 0; data < locationDataArray.count; data++)
                        {
                            
                            locationDataDict = [[NSMutableDictionary alloc]init];
                            
//                            [locationDataDict setObject:[[locationDataArray objectAtIndex:data]objectForKey:@"package_name"] forKey:@"package_name"];
                            [locationDataDict setObject:[[locationDataArray objectAtIndex:data] objectForKey:@"package_info"] forKey:@"package_info"];
                            [locationDataDict setObject:[[locationDataArray objectAtIndex:data] objectForKey:@"order_id"] forKey:@"order_id"];
                            
                            [savedLocationArray addObject:locationDataDict];
                            
                        }
                        [locationTableview removeFromSuperview];
                        locationTableview = [[UITableView alloc]init];//WithFrame:CGRectMake(25,74,340,95)];
                        locationTableview.delegate=self;
                        locationTableview.dataSource=self;
                        locationTableview.allowsSelection = YES;
                        locationTableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                        locationTableview.backgroundColor=[UIColor clearColor];
                        locationTableview.showsVerticalScrollIndicator = NO;
                        [editoxfordmapView addSubview:locationTableview];
                        DebugLog(@"AKKKKKKKKKK------------> %@",savedLocationArray);
                        
                        
                        if([[UIScreen mainScreen]bounds].size.width == 320)
                        {
                            locationTableview.frame = CGRectMake(25,120,260,77);
                        }
                        else
                        {
                            locationTableview.frame = CGRectMake(25,120,340,77);
                        }
                        
                        
                    }
                }];
            }
            
        }
        else
        {
            NSLog(@"asche oxford");
            
        [PickerBckView setHidden:YES];
        [oxfordPicker setHidden:YES];
        [DoneButton setHidden:YES];
        [CancelButton setHidden:YES];
        editoxfordmapView.ButtonLabel.text = [NSString stringWithFormat:@"%@",DataString];
//        [editoxfordmapView.orderDropdownButton setBackgroundColor:[UIColor greenColor]];
        [editoxfordmapView.orderDropdownButton setHidden:NO];
        
        }
      }
    else
    {
    [PickerBckView setHidden:YES];
    [DataPickerView setHidden:YES];
    [DoneButton setHidden:YES];
    [CancelButton setHidden:YES];
    EditView.ButtonLabel.text = [NSString stringWithFormat:@"%@",DataString];
//    EditView.DescriptionText.text = [NSString stringWithFormat:@"%@",descString];   //------for description***
    
    activityIndi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndi.backgroundColor=[UIColor clearColor];
    activityIndi.hidesWhenStopped = YES;
    activityIndi.frame=CGRectMake(160.0f,90.0f,50.0f,50.0f);
    activityIndi.userInteractionEnabled=YES;
    //                activityCheck = YES;
    [activityIndi startAnimating];
    [EditView addSubview: activityIndi];
    
    //    ---------------------For Package List-----------------
    
    if (globalClass.connectedToNetwork == YES ) {

            
            [globalClass GlobalStringDict:[NSString stringWithFormat:@"action.php?mode=packageList&orderId=%@",orderID] Globalstr:@"" Withblock:^(id result, NSError *error) {
        
            DebugLog(@"location DATA RETURN DATA--------->%@",result);
            
            if ([[result objectForKey:@"message"] isEqualToString:[NSString Noorderfound] ]|| [[result objectForKey:@"locationdata"] isKindOfClass:[NSNull class]] || [result objectForKey:@"locationdata"]  == (id)[NSNull null]) {
                
                DebugLog(@"NO ORDER FOUND");
                
                [activityIndi stopAnimating];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No order found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }else{
                
                DebugLog(@"ESLE COMING=============>");
                
                [savedLocationArray removeAllObjects];
                
                locationDataArray = [result objectForKey:@"locationdata"];
            for (data = 0; data < locationDataArray.count; data++)
            {
                    
                    locationDataDict = [[NSMutableDictionary alloc]init];
                    
                    [locationDataDict setObject:[[locationDataArray objectAtIndex:data]objectForKey:@"package_name"] forKey:@"package_name"];
                    [locationDataDict setObject:[[locationDataArray objectAtIndex:data] objectForKey:@"package_price"] forKey:@"package_price"];
                    [locationDataDict setObject:[[locationDataArray objectAtIndex:data] objectForKey:@"package_id"] forKey:@"package_id"];
                    
                    [savedLocationArray addObject:locationDataDict];
                    
            }
                [locationTableview removeFromSuperview];
                locationTableview = [[UITableView alloc]init];//WithFrame:CGRectMake(25,74,340,95)];
                locationTableview.delegate=self;
                locationTableview.dataSource=self;
                locationTableview.allowsSelection = YES;
                locationTableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                locationTableview.backgroundColor=[UIColor clearColor];
                locationTableview.showsVerticalScrollIndicator = NO;
                [EditView addSubview:locationTableview];
                DebugLog(@"AKKKKKKKKKK------------> %@",savedLocationArray);
                

                if([[UIScreen mainScreen]bounds].size.width == 320)
                {
                    locationTableview.frame = CGRectMake(25,74,260,95);
                }
                else
                {
                   locationTableview.frame = CGRectMake(25,74,340,95);
                }
                
                
            }
        }];
    }
    }
    
}

-(void)CancelButton:(UIButton *)sender
{
    [PickerBckView setHidden:YES];
    [DataPickerView setHidden:YES];
    [DoneButton setHidden:YES];
    [CancelButton setHidden:YES];
    [oxfordPicker setHidden:YES];
}

- (void)dragAndDrop:(UIPanGestureRecognizer *)gestureRecognizer targetView:(TGBecons *)targetView
{
    UIView *piece = [gestureRecognizer view];
    
    SelectedBecons = targetView;
    
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer targetView:targetView];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        
        if (piece.frame.origin.y >4)
        {
            
            
            
            BeconsView = [[TGBecons alloc]init];
            BeconsView.TgDelegate = self;
            [BeconsView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Becons"]]];
            [BeconsView configure];
            [BackGroundView addSubview:BeconsView];
            [DisableView setHidden:NO];
            
            if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
            {
                
                BeconsView.frame = CGRectMake(self.view.frame.size.width-105, 23, 40, 40);;
            }
            else
            {
                BeconsView.frame = CGRectMake(865, 23, 40, 40);
            }
            
            
        }
    }
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer targetView:(TGBecons *)targetView
{
    UIView *piece = [gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
         NSLog(@"---- %f------%f-------%f------%f",piece.frame.origin.x,piece.frame.origin.y,piece.frame.size.width,piece.frame.size.height);
        
        
        if (piece.frame.origin.y >68)
        {
            DebugLog(@"MAP PIN SMALL VIEW IS OPENNING");
            
            //    ------------------PK----------------12-6-15-----------//
            BeconsView.userInteractionEnabled = NO;
            if (globalClass.connectedToNetwork == YES) {
                
                if ([self.Type isEqualToString:@"Oxford"])
                {
                    
                  [globalClass parameterstring:@"action.php?mode=eventList" withblock:^(id result, NSError *error) {
                      
                 
                    
                    DebugLog(@"eventlist : %@", result);
                    if ([[result objectForKey:@"message"] isEqualToString:[NSString Norecordfound] ]) {
                        
                        DebugLog(@"NO RECORD FOUND");
                        blankCheck = YES;
 
                    }else{
                        blankCheck = NO;
                        self.orderArrayDropdown = [[NSMutableArray alloc]init];
                        _eventArray = [[NSMutableArray alloc]init];
                        _eventArray = [result objectForKey:@"orderdata"];
                        
                         DebugLog(@"EVENT DATA------> %@",_eventArray);
                        
                        for (data = 0; data < _eventArray.count; data ++)
                        {
                            orderDict = [[NSMutableDictionary alloc]init];
                            
                            [orderDict setObject:[[_eventArray objectAtIndex:data]objectForKey:@"event_name"] forKey:@"event_name"];
                            [orderDict setObject:[[_eventArray objectAtIndex:data] objectForKey:@"event_date"] forKey:@"event_date"];
                            [orderDict setObject:[[_eventArray objectAtIndex:data]objectForKey:@"event_id"] forKey:@"event_id"];
                            [self.orderArrayDropdown addObject:orderDict];
                        }
                        [oxfordPicker reloadAllComponents];
                        
                    }
                       }];
                }
                else
                {
                [globalClass GlobalStringDict:[NSString stringWithFormat:@"action.php?mode=orderList&located=false&locationId=%@",self.locationId] Globalstr:@"" Withblock:^(id result, NSError *error) {
                     DebugLog(@"LOCATION IDDDDD-----> %@",self.locationId);
                    DebugLog(@"MAP GLOBAL CLASS RETURN DATA--------->%@",result);
                    
                    if ([[result objectForKey:@"message"] isEqualToString:[NSString Norecordfound] ]) {
                        
                        DebugLog(@"NO RECORD FOUND");
                        
                        blankCheck = YES;
                        
                    }else{
                        
                        [DataArray removeAllObjects];
                        
                        blankCheck = NO;
                        
                        orderArray = [[NSMutableArray alloc]init];
                        orderArray = [result objectForKey:@"orderdata"];
                        
                        DebugLog(@"ORDER DATA------> %@",orderArray);
                        DebugLog(@"ORDER DATA COUNT------> %lu",(unsigned long)orderArray.count);
                        
                        for (data = 0; data < orderArray.count; data ++)
                        {
                            orderDict = [[NSMutableDictionary alloc]init];
                            
                            [orderDict setObject:[[orderArray objectAtIndex:data]objectForKey:@"first_name"] forKey:@"first_name"];
                            [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"last_name"] forKey:@"last_name"];
                            [orderDict setObject:[[orderArray objectAtIndex:data]objectForKey:@"event_date"] forKey:@"event_date"];
                            [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"order_date"] forKey:@"order_date"];
                            [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"user_email"] forKey:@"user_email"];
                            [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"transaction_id"] forKey:@"transaction_id"];
                            [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"order_id"] forKey:@"order_id"];
                            [DataArray addObject:orderDict];
                        }
                        
                        [DataPickerView reloadAllComponents];
                    }
                    
                }];
            }
        }
            
         
            
         

            if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
            {
                
                //This is only for type of Oxford
                if ([self.Type isEqualToString:@"Oxford"])
                {
                    editoxfordmapView = [[TGMapoxfordedit alloc]init];
                    [editoxfordmapView.orderDropdownButton setHidden:YES];
                    [BackGroundView addSubview:editoxfordmapView];
                    if(self.view.frame.size.width == 320)
                    {
                        editoxfordmapView.frame = CGRectMake(0, 140, 320, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxford5s"];
                        
                        
                    }
                    else
                    {
                       editoxfordmapView.frame = CGRectMake(-8, 140, self.view.frame.size.width-10, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxford"];
                        
                    }
                    
                    
                }
                else
                {
                    EditView = [[TGMapEdit alloc]init];
                    [BackGroundView addSubview:EditView];
                if(self.view.frame.size.width == 320)
                {
                    EditView.frame = CGRectMake(0, 140, 320, 237.5f);
                    EditView.backview.image = [UIImage imageNamed:@"mappopupdown5s"];
                }
                else
                {
                    EditView.frame = CGRectMake(-8, 140, self.view.frame.size.width-10, 237.5f);
                    EditView.backview.image = [UIImage imageNamed:@"mappopupdown"];
                }
            }
                NSLog(@"---- %f------%f-------%f------%f",piece.frame.origin.x,piece.frame.origin.y,piece.frame.size.width,piece.frame.size.height);
                
            }
            else
            {
                
                if ([self.Type isEqualToString:@"Oxford"])
                {
                    editoxfordmapView = [[TGMapoxfordedit alloc]init];
                    [editoxfordmapView.orderDropdownButton setHidden:YES];
                    [BackGroundView addSubview:editoxfordmapView];
                    //BeconsView.userInteractionEnabled = NO;
                    NSLog(@"---- %f------%f-------%f------%f",piece.frame.origin.x,piece.frame.origin.y,piece.frame.size.width,piece.frame.size.height);
                    if ( piece.frame.origin.x< 650 && piece.frame.origin.y > 170 && piece.frame.origin.y< 515)
                    {
                        DebugLog(@"1st");
                        
                        editoxfordmapView.frame = CGRectMake(piece.frame.origin.x +30, piece.frame.origin.y-140, 387.5f, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxford"];
                        
                    }
                    else if (piece.frame.origin.x > 650 && piece.frame.origin.x < 1024 && piece.frame.origin.y > 170 && piece.frame.origin.y< 515)
                    {
                        DebugLog(@"2nd");
                        
                        editoxfordmapView.frame = CGRectMake(piece.frame.origin.x-380, piece.frame.origin.y-140, 387.5f, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxfordright"];
                        
                    }
                    else if (piece.frame.origin.x > 0 && piece.frame.origin.x< 650 && piece.frame.origin.y < 170 && piece.frame.origin.y > 0)
                    {
                        DebugLog(@"3rd");
                        
                        editoxfordmapView.frame = CGRectMake(piece.frame.origin.x-140, piece.frame.origin.y+45, 387.5f, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxfordup"];
                    }
                    else if (piece.frame.origin.x > 650 && piece.frame.origin.x < 980 && piece.frame.origin.y < 170 && piece.frame.origin.y > 0)
                    {
                        DebugLog(@"4th");
                        
                        editoxfordmapView.frame = CGRectMake(piece.frame.origin.x-300, piece.frame.origin.y+45, 387.5f, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxfordup"];
                    }
                    else if (piece.frame.origin.x > 0 && piece.frame.origin.x< 650 && piece.frame.origin.y > 515 && piece.frame.origin.y < 729)
                    {
                        DebugLog(@"5th");
                        
                        editoxfordmapView.frame=CGRectMake(piece.frame.origin.x-30, piece.frame.origin.y-250, 387.5f, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxforddown"];
                    }
                    else if (piece.frame.origin.x > 650 && piece.frame.origin.x < 980 && piece.frame.origin.y > 515 && piece.frame.origin.y < 729)
                    {
                        DebugLog(@"7th");
                        
                        editoxfordmapView.frame = CGRectMake(piece.frame.origin.x-330, piece.frame.origin.y-250, 387.5f, 300.5f);
                        editoxfordmapView.backview.image = [UIImage imageNamed:@"mappopupoxforddown"];
                    }

                }
                else
                {
                EditView = [[TGMapEdit alloc]init];
                [BackGroundView addSubview:EditView];
                //BeconsView.userInteractionEnabled = NO;
             NSLog(@"---- %f------%f-------%f------%f",piece.frame.origin.x,piece.frame.origin.y,piece.frame.size.width,piece.frame.size.height);
            if ( piece.frame.origin.x< 650 && piece.frame.origin.y > 170 && piece.frame.origin.y< 515)
            {
                DebugLog(@"1st");
                
                EditView.frame = CGRectMake(piece.frame.origin.x +30, piece.frame.origin.y-140, 387.5f, 237.5f);
                EditView.backview.image = [UIImage imageNamed:@"mappopup"];
              
            }
            else if (piece.frame.origin.x > 650 && piece.frame.origin.x < 1024 && piece.frame.origin.y > 170 && piece.frame.origin.y< 515)
            {
                 DebugLog(@"2nd");
                
                EditView.frame = CGRectMake(piece.frame.origin.x-380, piece.frame.origin.y-140, 387.5f, 237.5f);
                EditView.backview.image = [UIImage imageNamed:@"mappopupright"];
       
            }
            else if (piece.frame.origin.x > 0 && piece.frame.origin.x< 650 && piece.frame.origin.y < 170 && piece.frame.origin.y > 0)
            {
                DebugLog(@"3rd");
                
                EditView.frame = CGRectMake(piece.frame.origin.x-140, piece.frame.origin.y+45, 387.5f, 237.5f);
                EditView.backview.image = [UIImage imageNamed:@"mappopupup"];
            }
            else if (piece.frame.origin.x > 650 && piece.frame.origin.x < 980 && piece.frame.origin.y < 170 && piece.frame.origin.y > 0)
            {
                DebugLog(@"4th");
                
                EditView.frame = CGRectMake(piece.frame.origin.x-300, piece.frame.origin.y+45, 387.5f, 237.5f);
                EditView.backview.image = [UIImage imageNamed:@"mappopupup"];
            }
            else if (piece.frame.origin.x > 0 && piece.frame.origin.x< 650 && piece.frame.origin.y > 515 && piece.frame.origin.y < 729)
            {
                DebugLog(@"5th");
                
                EditView.frame=CGRectMake(piece.frame.origin.x-30, piece.frame.origin.y-250, 387.5f, 237.5f);
                EditView.backview.image = [UIImage imageNamed:@"mappopupdown"];
            }
            else if (piece.frame.origin.x > 650 && piece.frame.origin.x < 980 && piece.frame.origin.y > 515 && piece.frame.origin.y < 729)
            {
                DebugLog(@"7th");
                
                EditView.frame = CGRectMake(piece.frame.origin.x-330, piece.frame.origin.y-250, 387.5f, 237.5f);
                EditView.backview.image = [UIImage imageNamed:@"mappopupdown"];
            }
            }
            DebugLog(@"piece------ %f--------%f",piece.frame.origin.x,piece.frame.origin.y);
            
            CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
            locationManager=[[CLLocationManager alloc]init];
            locationManager.delegate = self;
            [locationManager startUpdatingLocation];
            

            CGPoint touchPoint = CGPointMake(SelectedBecons.frame.origin.x+23, SelectedBecons.frame.origin.y-30);
            
            
            touchCoordinate = [mapView_ convertPoint:touchPoint toView:mapView_];
            
            CLLocationCoordinate2D coordinate = [mapView_.projection coordinateForPoint: touchCoordinate];
            
            float lat = coordinate.latitude;
            float lng = coordinate.longitude;
            
            DebugLog(@"lat long----- %f----- %f",lat,lng);
            
            [[NSUserDefaults standardUserDefaults]setFloat:lat forKey:@"arrive_lat"];
            
            [[NSUserDefaults standardUserDefaults]setFloat:lng forKey:@"arrive_long"];
            
            CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            
            [geocoder1 reverseGeocodeLocation:LocationAtual completionHandler:
             ^(NSArray *placemarks, NSError *error) {
                 
                 //Get address
                 CLPlacemark *placemark1 = [placemarks objectAtIndex:0];
                 
                 
                 //String to address
                 NSString *locatedaddress = [[placemark1.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 
                 DebugLog(@"locateaddress------ %@",locatedaddress);
                 
             }];
            
             [DisableView setHidden:NO];
            }
        }
        else if (piece.frame.origin.y<67)
        {
            [BeconsView removeFromSuperview];
            BeconsView.userInteractionEnabled = YES;
            [targetView removeFromSuperview];
            [DisableView setHidden:YES];
            
            BeconsView = [[TGBecons alloc]init];
            BeconsView.TgDelegate = self;
            [BeconsView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Becons"]]];
            [BeconsView configure];
            [BackGroundView addSubview:BeconsView];
            if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
            {
                
                BeconsView.frame = CGRectMake(self.view.frame.size.width-105, 23, 40, 40);;
            }
            else
            {
                BeconsView.frame = CGRectMake(865, 23, 40, 40);
            }
        }
        
    }
}
- (void)controlOverlap:(TGBecons *)anchorTable
{
    NSArray *subviewsArray = [editorArea subviews];
    for (TGBecons *SingleView in subviewsArray) {
        if (anchorTable.tag != SingleView.tag) {
            [self isOverLapping:anchorTable targetTable:SingleView];
        }
    }
}
- (void)isOverLapping:(TGBecons *)anchorTable targetTable:(TGBecons *)targetTable
{
    
    if(CGRectIntersectsRect([anchorTable frame], [targetTable frame])) {
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             
                             float overlpX;
                             if(targetTable.frame.size.width + targetTable.frame.origin.x + 20.0f >= editorArea.frame.size.width){
                                 
                                 overlpX = editorArea.frame.origin.x + 30;
                                 
                             }else{
                                 
                                 overlpX = (targetTable.frame.size.width + targetTable.frame.origin.x + 20.0f);
                             }
                             
                             [anchorTable setFrame:CGRectMake(overlpX, anchorTable.frame.origin.y, anchorTable.frame.size.width, anchorTable.frame.size.height)];
                             
                             
                         }
         
                         completion:^(BOOL finished) {
                             [self controlOverlap:anchorTable];
                         }];
    } else {
        return;
    }
    return;
}
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    DebugLog(@"image---: %@",img);
    
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}
- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    
    searchtext = [NSString stringWithFormat:@"%@",[SearchTextfield.text stringByReplacingCharactersInRange:range withString:string]];
    
    if ([searchtext isEqualToString:@""]) {
        
        [searchtableview setHidden:YES];
    }
    else{
        [searchtableview setHidden:NO];
    }
    [self data];
    return YES;
}
-(void)data
{
    
    [downloadQueue addOperationWithBlock:^{
        
        NSError *error = nil;
        
        NSData *searchdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=AIzaSyCIrFex6nrxUygg6QS31p0cYC-nS6pV6QI",[searchtext stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] options:NSDataReadingUncached error:&error];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:searchdata options:kNilOptions error:&error];
        
        DebugLog(@"dict---%@", dict);
        
        searchresult = [dict objectForKey:@"predictions"];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [searchtableview reloadData];
        }];
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locationDataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [activityIndi stopAnimating];
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = NO;
    
    
    if ([self.Type isEqualToString:@"Oxford"])
    {
        UILabel *textlbl = [[UILabel alloc] init];
        
        //-----Checking if iPhone 6 or not----//
        
        if ([UIScreen mainScreen].bounds.size.width > 320) {
            
            textlbl.frame = CGRectMake(5, 5, 290, 30);
        }else{
            
            textlbl.frame = CGRectMake(5, 5, 220, 30);
        }
        
        //-----Adjusting font size according to string length-----//
        
        if ([[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_info"] length] > 23) {
            
            [textlbl setFont:[UIFont systemFontOfSize:10.0f]];
            
        }else{
            
            [textlbl setFont:[UIFont systemFontOfSize:15.0f]];
        }
        
        textlbl.text = [NSString stringWithFormat:@"%@",[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_info"]];
        [textlbl setTextColor:[UIColor BlackColor]];
        [textlbl setBackgroundColor:[UIColor ClearColor]];
        
        [cell addSubview:textlbl];
    
    }else{
    
        UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
        textlbl.text = [NSString stringWithFormat:@"%@ %@",[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_name"],[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_price"]];
        [textlbl setTextColor:[UIColor BlackColor]];
        [textlbl setBackgroundColor:[UIColor ClearColor]];
        [textlbl setFont:[UIFont systemFontOfSize:15.0f]];
        [cell addSubview:textlbl];
        
    }
    
    checkbox = [[UIButton alloc]init];//WithFrame:CGRectMake(cell.frame.origin.x+cell.frame.size.width-10.0f, 14, 15.0f, 15.0f)];
    [checkbox setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    checkbox.tag=indexPath.row;
    [cell addSubview:checkbox];
    
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
        checkbox.frame = CGRectMake(245, 14, 15.0f, 15.0f);
    }
    else
    {
        checkbox.frame = CGRectMake(cell.frame.origin.x+cell.frame.size.width-10.0f, 14, 15.0f, 15.0f);
    }
    
    if (check_box_number==indexPath.row)
    {
         [checkbox setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else
    {
         [checkbox setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *getcell=(UITableView *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSArray *subArray=[getcell subviews];
    
    for (UIButton *btn in subArray)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            if (btn.tag==indexPath.row)
            {
                [checkbox setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                
                check_box_number=indexPath.row;
                
                finalorderID = [NSString stringWithFormat:@"%@",[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"order_id"]];
                packageInfo = [NSString stringWithFormat:@"%@",[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_info"]];
                self.packegeIdString = [NSString stringWithFormat:@"%@",[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_id"]];
                self.packegeNameString = [NSString stringWithFormat:@"%@ %@",[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_name"],[[savedLocationArray objectAtIndex:indexPath.row] objectForKey:@"package_price"]];
                EditView.submitButton.alpha = 1.0f;
                editoxfordmapView.submitButton.alpha = 1.0f;
                [locationTableview reloadData];
            }
            else
            {
                [btn setImage:[UIImage imageNamed:@"tick2"] forState:UIControlStateNormal];
                
                [locationTableview reloadData];
            }
            
        }
        
        
    }
    
}
-(void)Search:(UIButton *)sender
{
    if ([SearchTextfield.text isEqualToString:@""])
    {
        
    }
    else
    {
        DebugLog(@"field,,,, %@", SearchTextfield.text);
        
        
        NSString *esc_addr =  [SearchTextfield.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        
        NSData *adressdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr]] options:NSDataReadingUncached error:&error];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:adressdata options:kNilOptions error:&error];
        
        array = [[NSMutableArray alloc]init];
        
        array = [dict objectForKey:@"results"];
        
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[NSString stringWithFormat:@"%@",[[[[array objectAtIndex:0]objectForKey:@"geometry"]  objectForKey:@"location"] objectForKey:@"lat"]] floatValue]
                                                                longitude:[[NSString stringWithFormat:@"%@",[[[[array objectAtIndex:0]objectForKey:@"geometry"]  objectForKey:@"location"] objectForKey:@"lng"]] floatValue]
                                                                     zoom:18];
        mapView_.camera = camera;
    }
}
-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition*)position {
    zoommap = mapView_.camera.zoom;
    
    DebugLog(@"zoom gms---- %d", zoommap);
    // handle you zoom related logic
}

-(void)BackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finalURLFire{
    
    DebugLog(@"packegeid---- %@",img);
    
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.8f);
    
    if (globalClass.connectedToNetwork == YES ) {
        
        
      
            NSDictionary *dict = [globalClass saveStringDict:[NSString stringWithFormat:@"action.php?mode=chooseLocation&packageId=%@&orderId=%@&lat=%@&long=%@&sectionid=%@&place=&packagetype=&distance=&color=&road=&userid=%@",self.packegeIdString,orderID,[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"],[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"],self.locationId,[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]] savestr:@"string" saveimagedata:imageData ];
            
            NSLog(@"dict--- %@",dict);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString success] message:@"Successfuly Submitted" delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles:nil, nil];
            
            [alert show];
            
        
  
    }
    
}
///////-----------AfterSavePopUpView----.-----/////////

-(void)PlaceButton:(UIButton *)sender
{
    
    [PopupPicker selectRow:0 inComponent:0 animated:NO];
     savepickerName = [NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"name"]];
    self.savePlaceId = [NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"id"]];

    CheckString = @"Place";
    AfterSavePickerView.hidden = NO;
    PopupPicker.hidden = NO;
    PopupDoneButton.hidden = NO;
    PopupCancelButton.hidden = NO;
    self.GlobalPickerArray = self.PlaceaArray;
    [PopupPicker reloadAllComponents];

}
-(void)PackageButton:(UIButton *)sender
{
    [PopupPicker selectRow:0 inComponent:0 animated:NO];
    savepickerName = [NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"name"]];
    self.savePackegeId = [NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"id"]];
    CheckString = @"package";
     AfterSavePickerView.hidden = NO;
    PopupPicker.hidden = NO;
    PopupDoneButton.hidden = NO;
    PopupCancelButton.hidden = NO;
    self.GlobalPickerArray = self.PackageArray;
    [PopupPicker reloadAllComponents];
}
-(void)DistanceButton:(UIButton *)sender
{
    [PopupPicker selectRow:0 inComponent:0 animated:NO];
    savepickerName = [NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"name"]];
    self.saveDistanceId = [NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"id"]];
    CheckString = @"Distance";
     AfterSavePickerView.hidden = NO;
    PopupPicker.hidden = NO;
    PopupDoneButton.hidden = NO;
    PopupCancelButton.hidden = NO;
    self.GlobalPickerArray = self.DistanceArray;
    [PopupPicker reloadAllComponents];
}
-(void)RoadButton:(UIButton *)sender
{
 [PopupPicker selectRow:0 inComponent:0 animated:NO];
        savepickerName = [NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"name"]];
    self.saveRoadId = [NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"id"]];
    CheckString = @"Road";
     AfterSavePickerView.hidden = NO;
    PopupPicker.hidden = NO;
    PopupDoneButton.hidden = NO;
    PopupCancelButton.hidden = NO;
    self.GlobalPickerArray = self.RoadArray;
    [PopupPicker reloadAllComponents];
}
-(void)ColorButton:(UIButton *)sender
{
    [PopupPicker selectRow:0 inComponent:0 animated:NO];
        savepickerName = [NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"name"]];
    self.saveColorId = [NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:[PopupPicker selectedRowInComponent:0]] objectForKey:@"id"]];
    CheckString = @"color";
     AfterSavePickerView.hidden = NO;
    PopupPicker.hidden = NO;
    PopupDoneButton.hidden = NO;
    PopupCancelButton.hidden = NO;
    self.GlobalPickerArray = self.ColorArray;
    [PopupPicker reloadAllComponents];
}
-(void)PickerDone:(UIButton *)sender
{
    [AfterSavePickerView setHidden:YES];
    PopupPicker.hidden = YES;
    PopupDoneButton.hidden = YES;
    PopupCancelButton.hidden = YES;
    
    if ([CheckString isEqualToString:@"Place"])
    {
        [MapSave.PlacesLabel setTitle:savepickerName forState:UIControlStateNormal];
        [mapSaveIphone.PlacesLabel setTitle:savepickerName forState:UIControlStateNormal];
    }
    else if ([CheckString isEqualToString:@"package"])
    {
        [MapSave.PackegeLabel setTitle:savepickerName forState:UIControlStateNormal];
        [mapSaveIphone.PackegeLabel setTitle:savepickerName forState:UIControlStateNormal];
    }
    else if ([CheckString isEqualToString:@"Distance"])
    {
        [MapSave.DistanceLabel setTitle:savepickerName forState:UIControlStateNormal];
        [mapSaveIphone.DistanceLabel setTitle:savepickerName forState:UIControlStateNormal];
    }
    else if ([CheckString isEqualToString:@"Road"])
    {
        [MapSave.RoadLabel setTitle:savepickerName forState:UIControlStateNormal];
        [mapSaveIphone.RoadLabel setTitle:savepickerName forState:UIControlStateNormal];
    }
    else if ([CheckString isEqualToString:@"color"])
    {
        [MapSave.ColorLabel setTitle:savepickerName forState:UIControlStateNormal];
        [mapSaveIphone.ColorLabel setTitle:savepickerName forState:UIControlStateNormal];
    }
    
}
-(void)FinalSubmit:(UIButton *)sender
{
    
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0f);
    
    if (globalClass.connectedToNetwork == YES ) {
        
        NSDictionary*dict = [globalClass saveStringDict:[NSString stringWithFormat:@"action.php?mode=chooseLocation&packageId=1&orderId=%@&lat=%@&long=%@&sectionid=%@&place=%@&packagetype=%@&distance=%@&color=%@&road=%@&userid=%@",finalorderID,[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"],[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"],self.locationId,self.savePlaceId,self.savePackegeId,self.saveDistanceId,self.saveColorId,self.saveRoadId,[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]] savestr:@"string" saveimagedata:imageData];
            
            DebugLog(@"result--- %@",dict);

        
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString success] message:@"Successfuly Submitted" delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles:nil, nil];
                
                [alert show];
                

         [self firstdata];

        
    [MapSave removeFromSuperview];
       
    [mapSaveIphone removeFromSuperview];
    [SelectedBecons removeFromSuperview];
    [EditView setHidden:YES];
 }

    
}
-(void)FinalCanCel:(UIButton *)sender
{
    [self firstdata];
    
    [MapSave removeFromSuperview];
    [mapSaveIphone removeFromSuperview];
}
-(void)PickerCancelButton:(UIButton *)sender
{
    [AfterSavePickerView setHidden:YES];
    PopupPicker.hidden = YES;
    PopupDoneButton.hidden = YES;
    PopupCancelButton.hidden = YES;
}

#pragma mark - GMDraggableMarkerManagerDelegate.
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
    DebugLog(@">>> mapView:didBeginDraggingMarker: %@", [marker description]);
}
- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    
}
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    NSLog(@"savedataarray---- %@", SavedDataArray);
    
    if([self.Type isEqualToString:@"Oxford"])
    {
        
        
        
        
        for (int k = 0; k <SavedDataArray.count; k++)
        {
            if ([marker.userData isEqualToString:[NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"tag"]]])
            {
                NSLog(@"savedataarray-=-==--= %@", [[SavedDataArray objectAtIndex:k]objectForKey:@"tag"]);
                
                self.packegeIdString = [[SavedDataArray objectAtIndex:k]objectForKey:@"package_id"];
                finalorderID = [[SavedDataArray objectAtIndex:k]objectForKey:@"order_id"];
                editOrderDate = [NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"event_date"]];
                editPackageName = [[SavedDataArray objectAtIndex:k]objectForKey:@"package_name"];
                editOrderFirstName =[[SavedDataArray objectAtIndex:k]objectForKey:@"firstname"];
                editOrderSecondName = [[SavedDataArray objectAtIndex:k]objectForKey:@"lastname"];
                self.savePlaceId = [[SavedDataArray objectAtIndex:k]objectForKey:@"placeid"];
                self.savePackegeId = [[SavedDataArray objectAtIndex:k]objectForKey:@"pktyid"];
                self.saveDistanceId = [[SavedDataArray objectAtIndex:k]objectForKey:@"distanceid"];
                self.saveColorId = [[SavedDataArray objectAtIndex:k]objectForKey:@"colorid"];
                self.saveRoadId = [[SavedDataArray objectAtIndex:k]objectForKey:@"roadid"];
                editOxfordEventName = [[SavedDataArray objectAtIndex:k]objectForKey:@"event_name"];
                break;
            }
            
        }
        
        
        
        if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
        {
            mapSaveIphone = [[TGMapSaveiphone alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:mapSaveIphone];
        }
        else
        {
            MapSave = [[TGMapSave alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:MapSave];
        }
        
        UIView *screenshotview = [[UIView alloc]initWithFrame:CGRectMake(1025, 72.0f, 1024, 698)];
        [screenshotview setBackgroundColor:[UIColor clearColor]];
        [BackGroundView addSubview:screenshotview];
        
        
        NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&zoom=%d&size=1024x698&sensor=true",marker.position.latitude,marker.position.longitude,zoommap];
        
        
        
        NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
        
        MapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, 1024, 698)];
        [MapView setImage:image];
        [screenshotview addSubview:MapView];
        
        
        UIImageView *backview = [[UIImageView alloc]initWithFrame:CGRectMake(315.0f, 102.0f, 387.5f, 237.5f)];
        [backview setImage:[UIImage imageNamed:@"mappopupdown"]];
        [screenshotview addSubview:backview];
        
        
        NSLog(@"----- %@----%@---- %@----- %@----%@",editOxfordEventName,editOrderDate,editOrderFirstName,editOrderSecondName,editPackageName);
        
        UILabel *ButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0f,23.0f, 340.0f, 45.0f)];
        [ButtonLabel setBackgroundColor:[UIColor clearColor]];
        [ButtonLabel setText:[NSString stringWithFormat:@"%@%@",editOxfordEventName,editOrderDate]];
        [ButtonLabel setTextAlignment:NSTextAlignmentLeft];
        [ButtonLabel setTextColor:[UIColor BlackColor]];
        [ButtonLabel setFont:[UIFont ButtonLabel]];
        [backview addSubview:ButtonLabel];
        
        UITextView *_DescriptionText = [[UITextView alloc]initWithFrame:CGRectMake(25,75,340,120)];
        _DescriptionText.font = [UIFont ButtonLabel];
        _DescriptionText.backgroundColor = [UIColor clearColor];
        _DescriptionText.textColor = [UIColor BlackColor];
        _DescriptionText.scrollEnabled = YES;
        _DescriptionText.pagingEnabled = YES;
        _DescriptionText.editable = NO;
        _DescriptionText.delegate = self;
        _DescriptionText.text = [NSString stringWithFormat:@"%@ %@\n%@",editOrderFirstName,editOrderSecondName,editPackageName];
        _DescriptionText.layer.borderWidth = 1.5f;
        _DescriptionText.layer.borderColor = [[UIColor colorWithRed:(179.0f/255.0f) green:(179.0f/255.0f) blue:(179.0f/255.0f) alpha:1] CGColor];
        _DescriptionText.textAlignment = NSTextAlignmentLeft;
        _DescriptionText.layer.cornerRadius = 3.0f;
        [_DescriptionText setAutocorrectionType:UITextAutocorrectionTypeNo];
        [backview addSubview:_DescriptionText];
        
        [self imageWithView:screenshotview];
        
        
        
      
        
        //////////////-================AfterSavePickerView==========///////////////
        
        AfterSavePickerView  = [[UIView alloc]init];
        [AfterSavePickerView setBackgroundColor:[UIColor whiteColor]];
        [AfterSavePickerView setAlpha:1.0f];
        [self.view addSubview:AfterSavePickerView];
        [AfterSavePickerView setHidden:YES];
        
        PopupPicker = [[UIPickerView alloc] init];
        PopupPicker.layer.zPosition=9;
        PopupPicker.backgroundColor=[UIColor clearColor];
        PopupPicker.dataSource = self;
        PopupPicker.delegate = self;
        PopupPicker.tag = 2;
        PopupPicker.showsSelectionIndicator = YES;
        [self.view addSubview:PopupPicker];
        [PopupPicker setHidden:YES];
        
        PopupDoneButton = [[UIButton alloc]init];
        [PopupDoneButton setBackgroundColor:[UIColor clearColor]];
        [PopupDoneButton setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
        [PopupDoneButton addTarget:self action:@selector(PickerDone:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PopupDoneButton];
        [PopupDoneButton setHidden:YES];
        
        PopupCancelButton = [[UIButton alloc]init];
        [PopupCancelButton setBackgroundColor:[UIColor clearColor]];
        [PopupCancelButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [PopupCancelButton addTarget:self action:@selector(PickerCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PopupCancelButton];
        [PopupCancelButton setHidden:YES];
        
        if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
        {
            AfterSavePickerView.frame = CGRectMake(0.0f,self.view.frame.size.height-210, self.view.frame.size.width, 210.0f);
            PopupPicker.frame = CGRectMake(0,self.view.frame.size.height-170, self.view.frame.size.width, 180.0f);
            PopupDoneButton.frame = CGRectMake(self.view.frame.size.width-190, self.view.frame.size.height-205, 83, 35);
            PopupCancelButton.frame = CGRectMake( self.view.frame.size.width-100, self.view.frame.size.height-205, 83, 35);
        }
        
        else
        {
            AfterSavePickerView.frame = CGRectMake(0.0f,600.0f, self.view.frame.size.width, self.view.frame.size.height-500.0f);
            PopupPicker.frame = CGRectMake(0,600, self.view.frame.size.width, self.view.frame.size.height-530.0f);
            PopupDoneButton.frame = CGRectMake(900, 610, 83, 35);
            PopupCancelButton.frame = CGRectMake(800, 610, 83, 35);
        }
        
        
        
        if ([self.Type isEqualToString:@"Oxford"])
        {
            Typecheck = 2;
        }
        else
        {
            Typecheck = 1;
        }
        
        [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=placeInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
         {
             if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
             {
                 self.PlaceaArray = [result objectForKey:@"placeinfodata"];
                 
                 
                     for (int j = 0; j< self.PlaceaArray.count; j++)
                     {
                         if ([self.savePlaceId isEqualToString:[NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:j]objectForKey:@"id"]]])
                         {
                             if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
                             {
                                 [mapSaveIphone.PlacesLabel setTitle:@"" forState:UIControlStateNormal];
                                 [mapSaveIphone.PlacesLabel setTitle:[NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                             }
                             else
                             {
                                 [MapSave.PlacesLabel setTitle:@"" forState:UIControlStateNormal];
                                 [MapSave.PlacesLabel setTitle:[NSString stringWithFormat:@"%@",[[self.PlaceaArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                             }
                             break;
                         }
                     }
                     
                 
                 }
                 else
                 {
                     
                 }
           
             [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=packagetypeInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
              {
                  if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                  {
                      self.PackageArray = [result objectForKey:@"packagetypedata"];
                      
                      for (int j = 0; j< self.PackageArray.count; j++)
                      {
                          if ([self.savePackegeId isEqualToString:[NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:j]objectForKey:@"id"]]])
                          {
                              if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
                              {
                                  [mapSaveIphone.PackegeLabel setTitle:@"" forState:UIControlStateNormal];
                                  [mapSaveIphone.PackegeLabel setTitle:[NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                              }
                              else
                              {
                                  [MapSave.PackegeLabel setTitle:@"" forState:UIControlStateNormal];
                                  [MapSave.PackegeLabel setTitle:[NSString stringWithFormat:@"%@",[[self.PackageArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                              }
                              break;
                          }
                          
                      }

                  }
                  else{
                      
                      
                  }
                  [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=distanceInfo"] Withblock:^(id result, NSError *error)
                   {
                       if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                       {
                           self.DistanceArray = [result objectForKey:@"distancedata"];
                           
                           for (int j = 0; j< self.DistanceArray.count; j++)
                           {
                               if ([self.saveDistanceId isEqualToString:[NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:j]objectForKey:@"id"]]])
                               {
                                   if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
                                   {
                                       [mapSaveIphone.DistanceLabel setTitle:@"" forState:UIControlStateNormal];
                                       [mapSaveIphone.DistanceLabel setTitle:[NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                                   }
                                   else
                                   {
                                       [MapSave.DistanceLabel setTitle:@"" forState:UIControlStateNormal];
                                       [MapSave.DistanceLabel setTitle:[NSString stringWithFormat:@"%@",[[self.DistanceArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                                   }
                                   break;
                               }
                               
                           }

                       }
                       else
                       {
                           
                       }
                       [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=roadInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
                        {
                            if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                            {
                                self.RoadArray = [result objectForKey:@"roaddata"];
                                
                                for (int j = 0; j< self.RoadArray.count; j++)
                                {
                                    if ([self.saveRoadId isEqualToString:[NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:j]objectForKey:@"id"]]])
                                    {
                                        if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
                                        {
                                            [mapSaveIphone.RoadLabel setTitle:@"" forState:UIControlStateNormal];
                                            [mapSaveIphone.RoadLabel setTitle:[NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                                        }
                                        else
                                        {
                                            [MapSave.RoadLabel setTitle:@"" forState:UIControlStateNormal];
                                            [MapSave.RoadLabel setTitle:[NSString stringWithFormat:@"%@",[[self.RoadArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                                        }
                                         break;
                                    }
                                   
                                }
                            }
                            else{
                                
                                
                            }
                            [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=colorInfo"] Withblock:^(id result, NSError *error) {
                                if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                                {
                                    
                                    self.ColorArray = [result objectForKey:@"colordata"];
                                    
                                    for (int j = 0; j< self.ColorArray.count; j++)
                                    {
                                        if ([self.saveColorId isEqualToString:[NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:j]objectForKey:@"id"]]])
                                        {
                                            if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
                                            {
                                                [mapSaveIphone.ColorLabel setTitle:@"" forState:UIControlStateNormal];
                                                [mapSaveIphone.ColorLabel setTitle:[NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                                            }
                                            else
                                            {
                                                [MapSave.ColorLabel setTitle:@"" forState:UIControlStateNormal];
                                                [MapSave.ColorLabel setTitle:[NSString stringWithFormat:@"%@",[[self.ColorArray objectAtIndex:j]objectForKey:@"name"]] forState:UIControlStateNormal];
                                            }
                                             break;
                                        }
                                       
                                    }
                                }
                                else
                                {
                                    
                                }
                            }];
                            
                            
                        }];
                       
                       
                   }];
                  
                  
              }];
             
             
         }];

        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",marker.position.latitude] forKey:@"arrive_lat"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",marker.position.longitude] forKey:@"arrive_long"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {
        for (int k = 0; k <SavedDataArray.count; k++)
        {
            if ([marker.userData isEqualToString:[NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"tag"]]])
            {
                NSLog(@"savedataarray-=-==--= %@", [[SavedDataArray objectAtIndex:k]objectForKey:@"tag"]);
                
                editPackageId = [[SavedDataArray objectAtIndex:k]objectForKey:@"package_id"];
                editOrderId = [[SavedDataArray objectAtIndex:k]objectForKey:@"order_id"];
                editOrderDate = [NSString stringWithFormat:@"%@",[[SavedDataArray objectAtIndex:k]objectForKey:@"event_date"]];
                editPackageName = [[SavedDataArray objectAtIndex:k]objectForKey:@"package_name"];
                editOrderFirstName =[[SavedDataArray objectAtIndex:k]objectForKey:@"firstname"];
                editOrderSecondName = [[SavedDataArray objectAtIndex:k]objectForKey:@"lastname"];
                break;
            }
            
        }
        
        
        UIView *screenshotview = [[UIView alloc]initWithFrame:CGRectMake(1025, 72.0f, 1024, 698)];
        [screenshotview setBackgroundColor:[UIColor clearColor]];
        [BackGroundView addSubview:screenshotview];
        
        
        NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&zoom=%d&size=1024x698&sensor=true",marker.position.latitude,marker.position.longitude,zoommap];
        
        
        
        NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
        
        MapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, 1024, 698)];
        [MapView setImage:image];
        [screenshotview addSubview:MapView];
        
        
        UIImageView *backview = [[UIImageView alloc]initWithFrame:CGRectMake(315.0f, 102.0f, 387.5f, 237.5f)];
        [backview setImage:[UIImage imageNamed:@"mappopupdown"]];
        [screenshotview addSubview:backview];
        
        
        UILabel *ButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0f,23.0f, 340.0f, 45.0f)];
        [ButtonLabel setBackgroundColor:[UIColor clearColor]];
        [ButtonLabel setText:[NSString stringWithFormat:@"%@ %@  %@",editOrderFirstName,editOrderSecondName,editOrderDate]];
        [ButtonLabel setTextAlignment:NSTextAlignmentLeft];
        [ButtonLabel setTextColor:[UIColor BlackColor]];
        [ButtonLabel setFont:[UIFont ButtonLabel]];
        [backview addSubview:ButtonLabel];
        
        UITextView *_DescriptionText = [[UITextView alloc]initWithFrame:CGRectMake(25,75,340,120)];
        _DescriptionText.font = [UIFont ButtonLabel];
        _DescriptionText.backgroundColor = [UIColor clearColor];
        _DescriptionText.textColor = [UIColor BlackColor];
        _DescriptionText.scrollEnabled = YES;
        _DescriptionText.pagingEnabled = YES;
        _DescriptionText.editable = NO;
        _DescriptionText.delegate = self;
        _DescriptionText.text = [NSString stringWithFormat:@"%@",editPackageName];
        _DescriptionText.layer.borderWidth = 1.5f;
        _DescriptionText.layer.borderColor = [[UIColor colorWithRed:(179.0f/255.0f) green:(179.0f/255.0f) blue:(179.0f/255.0f) alpha:1] CGColor];
        _DescriptionText.textAlignment = NSTextAlignmentLeft;
        _DescriptionText.layer.cornerRadius = 3.0f;
        [_DescriptionText setAutocorrectionType:UITextAutocorrectionTypeNo];
        [backview addSubview:_DescriptionText];
        
        [self imageWithView:screenshotview];
        
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.8f);
        
        if (globalClass.connectedToNetwork == YES ) {
            
            NSDictionary *dict = [globalClass saveStringDict:[NSString stringWithFormat:@"action.php?mode=chooseLocation&packageId=%@&orderId=%@&lat=%f&long=%f&sectionid=%@&place=&packagetype=&distance=&color=&road=&userid=%@",editPackageId,editOrderId,marker.position.latitude,marker.position.longitude,self.locationId,[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]] savestr:@"string" saveimagedata:imageData ];
            
            NSLog(@"dict--- %@",dict);
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString success] message:@"Successfuly Submitted" delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        [self firstdata];
        
        
        DebugLog(@">>> mapView:didEndDraggingMarker:%f  ------  %f---- %@", marker.position.latitude,marker.position.longitude,marker.userData);

    }
}
- (void)mapView:(GMSMapView *)mapView didCancelDraggingMarker:(GMSMarker *)marker
{
    DebugLog(@">>> mapView:didCancelDraggingMarker: %@",[marker description]);
    
}

////oxford edit option//////

-(void)DropDownoxfordevent:(UIButton *)sender
{
    NSLog(@"entry");
    chekoxford = @"event";
    
    if (blankCheck == YES) {
        
        DebugLog(@"DATA ARRAY BLANK");
        
        UIAlertView *alertBlank = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No record found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertBlank show];
        
    }else{
    
        DebugLog(@"Dataarray------ %@", self.orderArrayDropdown);
        
        
        [PickerBckView setHidden:NO];
        [oxfordPicker setHidden:NO];
        [DoneButton setHidden:NO];
        [CancelButton setHidden:NO];
        
        [oxfordPicker selectRow:0 inComponent:0 animated:NO];
        DataString = [NSString stringWithFormat:@"%@  %@",[[self.orderArrayDropdown objectAtIndex:[oxfordPicker selectedRowInComponent:0]] objectForKey:@"event_name"],[[self.orderArrayDropdown objectAtIndex:[oxfordPicker selectedRowInComponent:0]] objectForKey:@"event_date"]];
        orderID = [[self.orderArrayDropdown objectAtIndex:[oxfordPicker selectedRowInComponent:0]] objectForKey:@"event_id"];

        
    
        
    }
}
-(void)DropDownoxfordorder:(UIButton *)sender
{
    chekoxford = @"order";
    
    DebugLog(@"DropDownOxfordOrder----->");
 
    if (globalClass.connectedToNetwork == YES) {
        
        [globalClass parameterstring:[NSString stringWithFormat:@"action.php?mode=oxfordOrderUserList&event_id=%@",orderID] withblock:^(id result, NSError *error) {
            
            if ([[result objectForKey:@"message"] isEqualToString:[NSString Norecordfound] ]) {
                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No order found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {
                [DataArray removeAllObjects];
          
                orderArray = [[NSMutableArray alloc]init];
                orderArray = [result objectForKey:@"orderdata"];
                
                DebugLog(@"ORDER DATA------> %@",orderArray);
                DebugLog(@"ORDER DATA COUNT------> %lu",(unsigned long)orderArray.count);
                
                for (data = 0; data < orderArray.count; data ++)
                {
                    orderDict = [[NSMutableDictionary alloc]init];
                    [orderDict setObject:[[orderArray objectAtIndex:data]objectForKey:@"first_name"] forKey:@"first_name"];
                    [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"last_name"] forKey:@"last_name"];
                    [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"event_id"] forKey:@"event_id"];
                    [orderDict setObject:[[orderArray objectAtIndex:data] objectForKey:@"buyer_id"] forKey:@"buyer_id"];
                    [DataArray addObject:orderDict];
                }
                [DataPickerView reloadAllComponents];
                
                [DataPickerView selectRow:0 inComponent:0 animated:NO];
                DataString = [NSString stringWithFormat:@"%@ %@",[[orderArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"first_name"],[[orderArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"last_name"]];
                eventID = [[orderArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"event_id"];
                buyerID = [[orderArray objectAtIndex:[DataPickerView selectedRowInComponent:0]] objectForKey:@"buyer_id"];
                
                DebugLog(@"ORDER STRING------> %@",orderString);
                DebugLog(@"ORDER STRING ID---> %@",orderID);
                
                [PickerBckView setHidden:NO];
                [DataPickerView setHidden:NO];
                [DoneButton setHidden:NO];
                [CancelButton setHidden:NO];
            }
            
        }];
       
        
    }
    
    
}
-(void)CanCeloxford:(UIButton *)sender
{
    [editoxfordmapView removeFromSuperview];
    [SelectedBecons setHidden:YES];
    [DisableView setHidden:YES];
}
-(void)Submitoxford:(UIButton *)sender
{
   
        if ([EditView.ButtonLabel.text isEqualToString:@"Select the order from list"])
        {
            
        }
        else
        {
             [editoxfordmapView removeFromSuperview];
            
            [DisableView setHidden:YES];
            
            UIView *screenshotview = [[UIView alloc]initWithFrame:CGRectMake(1025, 72.0f, 1024,698)];
            [screenshotview setBackgroundColor:[UIColor clearColor]];
            [BackGroundView addSubview:screenshotview];
            
            
            NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&zoom=%d&size=1024x698&sensor=true",[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"]]floatValue],[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"]]floatValue],zoommap];
            
            
            
            NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
            
            MapView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0f, 1024, 698)];
            [MapView setImage:image];
            [screenshotview addSubview:MapView];
            
            
            UIImageView *backview = [[UIImageView alloc]initWithFrame:CGRectMake(315.0f, 102.0f, 387.5f, 237.5f)];
            [backview setImage:[UIImage imageNamed:@"mappopupdown"]];
            [screenshotview addSubview:backview];
            
            
            UILabel *ButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(25.0f,23.0f, 340.0f, 45.0f)];
            [ButtonLabel setBackgroundColor:[UIColor clearColor]];
            [ButtonLabel setText:[NSString stringWithFormat:@"%@",editoxfordmapView.ButtonLabel.text]];
            [ButtonLabel setTextAlignment:NSTextAlignmentLeft];
            [ButtonLabel setTextColor:[UIColor BlackColor]];
            [ButtonLabel setFont:[UIFont ButtonLabel]];
            [backview addSubview:ButtonLabel];
            
            UITextView *_DescriptionText = [[UITextView alloc]initWithFrame:CGRectMake(25,75,340,120)];
            _DescriptionText.font = [UIFont ButtonLabel];
            _DescriptionText.backgroundColor = [UIColor clearColor];
            _DescriptionText.textColor = [UIColor BlackColor];
            _DescriptionText.scrollEnabled = YES;
            _DescriptionText.pagingEnabled = YES;
            _DescriptionText.editable = NO;
            _DescriptionText.delegate = self;
            _DescriptionText.text = [NSString stringWithFormat:@"%@\n%@",editoxfordmapView.orderButtonLabel.text,packageInfo];
            _DescriptionText.layer.borderWidth = 1.5f;
            _DescriptionText.layer.borderColor = [[UIColor colorWithRed:(179.0f/255.0f) green:(179.0f/255.0f) blue:(179.0f/255.0f) alpha:1] CGColor];
            _DescriptionText.textAlignment = NSTextAlignmentLeft;
            _DescriptionText.layer.cornerRadius = 3.0f;
            [_DescriptionText setAutocorrectionType:UITextAutocorrectionTypeNo];
            [backview addSubview:_DescriptionText];
            
            [self imageWithView:screenshotview];
            
            
            [SelectedBecons setButtonLabel:[NSString stringWithFormat:@"%@",EditView.ButtonLabel.text]];
            [SelectedBecons setDescriptionText:[NSString stringWithFormat:@"%@",EditView.DescriptionText.text]];
            
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_lat"]],@"lat",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"arrive_long"]],@"long", nil];
            
            [SavedDataArray addObject:dict];
            
            
            if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
            {
                mapSaveIphone = [[TGMapSaveiphone alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
                [self.view addSubview:mapSaveIphone];
            }
            else
            {
                MapSave = [[TGMapSave alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
                [self.view addSubview:MapSave];
            }
            
            //////////////-================AfterSavePickerView==========///////////////
            
            AfterSavePickerView  = [[UIView alloc]init];
            [AfterSavePickerView setBackgroundColor:[UIColor whiteColor]];
            [AfterSavePickerView setAlpha:1.0f];
            [self.view addSubview:AfterSavePickerView];
            [AfterSavePickerView setHidden:YES];
            
            PopupPicker = [[UIPickerView alloc] init];
            PopupPicker.layer.zPosition=9;
            PopupPicker.backgroundColor=[UIColor clearColor];
            PopupPicker.dataSource = self;
            PopupPicker.delegate = self;
            PopupPicker.tag = 2;
            PopupPicker.showsSelectionIndicator = YES;
            [self.view addSubview:PopupPicker];
            [PopupPicker setHidden:YES];
            
            PopupDoneButton = [[UIButton alloc]init];
            [PopupDoneButton setBackgroundColor:[UIColor clearColor]];
            [PopupDoneButton setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
            [PopupDoneButton addTarget:self action:@selector(PickerDone:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:PopupDoneButton];
            [PopupDoneButton setHidden:YES];
            
            PopupCancelButton = [[UIButton alloc]init];
            [PopupCancelButton setBackgroundColor:[UIColor clearColor]];
            [PopupCancelButton setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
            [PopupCancelButton addTarget:self action:@selector(PickerCancelButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:PopupCancelButton];
            [PopupCancelButton setHidden:YES];
            
            if ([device.model isEqualToString:@"iPhone"]||[device.model isEqualToString:@"iPhone Simulator"]||[device.model isEqualToString:@"iPod touch"] )
            {
                AfterSavePickerView.frame = CGRectMake(0.0f,self.view.frame.size.height-210, self.view.frame.size.width, 210.0f);
                PopupPicker.frame = CGRectMake(0,self.view.frame.size.height-170, self.view.frame.size.width, 180.0f);
                PopupDoneButton.frame = CGRectMake(self.view.frame.size.width-190, self.view.frame.size.height-205, 83, 35);
                PopupCancelButton.frame = CGRectMake( self.view.frame.size.width-100, self.view.frame.size.height-205, 83, 35);
            }
            
            else
            {
                AfterSavePickerView.frame = CGRectMake(0.0f,600.0f, self.view.frame.size.width, self.view.frame.size.height-500.0f);
                PopupPicker.frame = CGRectMake(0,600, self.view.frame.size.width, self.view.frame.size.height-530.0f);
                PopupDoneButton.frame = CGRectMake(900, 610, 83, 35);
                PopupCancelButton.frame = CGRectMake(800, 610, 83, 35);
            }
            
            
            
            if ([self.Type isEqualToString:@"Oxford"])
            {
                Typecheck = 2;
            }
            else
            {
                Typecheck = 1;
            }
            
            [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=placeInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
             {
                 if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                 {
                     self.PlaceaArray = [result objectForKey:@"placeinfodata"];
                     
                 }
                 else
                 {
                     
                     
                 }
                 [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=packagetypeInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
                  {
                      if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                      {
                          self.PackageArray = [result objectForKey:@"packagetypedata"];
                      }
                      else{
                          
                          
                      }
                      [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=distanceInfo"] Withblock:^(id result, NSError *error)
                       {
                           if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                           {
                               self.DistanceArray = [result objectForKey:@"distancedata"];
                           }
                           else
                           {
                               
                           }
                           [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=roadInfo&type=%d",Typecheck] Withblock:^(id result, NSError *error)
                            {
                                if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                                {
                                    self.RoadArray = [result objectForKey:@"roaddata"];
                                }
                                else{
                                    
                                    
                                }
                                [globalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=colorInfo"] Withblock:^(id result, NSError *error) {
                                    if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                                    {
                                        
                                        self.ColorArray = [result objectForKey:@"colordata"];
                                    }
                                    else
                                    {
                                        
                                    }
                                }];
                                
                                
                            }];
                           
                           
                       }];
                      
                      
                  }];
                 
                 
             }];
        }
        
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
