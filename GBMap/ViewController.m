//
//  ViewController.m
//  GBMap
//
//  Created by Даниил Мурыгин on 27.10.2020.
//

#import "ViewController.h"
#import "LocationService.h"

@interface ViewController ()
@property (nonatomic, strong) LocationService *locationService;
@property (strong, nonatomic) MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationService = [[LocationService alloc] init];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self addressFromLocation:[[CLLocation alloc]initWithLatitude:55.7522200 longitude:37.6155600]];
    [self.view addSubview:_mapView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addressFromLocation:currentLocation];
    });
}

- (void)addressFromLocation:(CLLocation *)location {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = placemark.administrativeArea;
                annotation.subtitle = placemark.name;
                annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,
                                                                   location.coordinate.longitude);
                [self.mapView addAnnotation:annotation];
            }
        }
        
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        if ([annotation.title  isEqual: @"My Location"]){return annotationView;}
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.annotation = annotation;
    return annotationView;
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
