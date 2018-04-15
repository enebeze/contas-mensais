//
//  AppDelegate.m
//  Contas Mensais
//
//  Created by Ebenezer Silva on 11/03/15.
//  Copyright (c) 2015 Ebenezer Silva. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - Defaults

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Inicializa o Google Analytics
    [self initGoogleAnalytics];
    
    // Verifica as notificações para testes
    //[self verificaTodasNotificacoes];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Caso a aplicação for iniciada através de uma notificação
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Lembrete", @"Titulo Alert") message:notification.alertBody delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    [self setupNotificationSettings];
    
    // Para de exibir os badge no ícone
    application.applicationIconBadgeNumber = 0;
    
    [self customizeIphoneTheme];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Para de exibir os badge no ícone
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //UIApplicationState state = [application applicationState];
    //if (state == UIApplicationStateActive) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Lembrete", @"Titulo Alert") message:notification.alertBody delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    //}
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"pagarAction"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pagarContaWithNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:notification forKey:@"not"]];
    }

    if (completionHandler) {
        
        completionHandler();
    }
}

#pragma mark - Meus métodos

-(void)setupNotificationSettings
{
    UIMutableUserNotificationAction *pagarAction = [[UIMutableUserNotificationAction alloc] init];
    pagarAction.identifier = @"pagarAction";
    pagarAction.title = @"Pagar Conta";
    pagarAction.activationMode = UIUserNotificationActivationModeBackground;
    pagarAction.destructive = YES;
    pagarAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *verContas = [[UIMutableUserNotificationAction alloc] init];
    verContas.identifier = @"verContas";
    verContas.title = @"Ver Contas";
    verContas.activationMode = UIUserNotificationActivationModeForeground;
    verContas.destructive = NO;
    verContas.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"notificationCategory";
    [category setActions:@[pagarAction, verContas] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *setCategory = [[NSSet alloc] initWithObjects:category, nil];
    
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:setCategory];

    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

-(void) verificaTodasNotificacoes
{
    // Recebe todas as notificações
    NSArray * allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    NSLog(@"Começo-----------------------");
    
    // Percorre todas as notificações
    for (UILocalNotification *not in allNotifications)
    {
        NSLog(@"Entrou-----------------------");
        // Mostra cada uma
        NSLog(@"Conta: %@", [not.userInfo objectForKey:@"Conta"]);
        NSLog(@"Fire Date: %@", not.fireDate);
    }
}

-(void) initGoogleAnalytics
{
    // Automanticamente envia exceções não tratadas
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Ajusta o intervalo do Google Analytics para 20 segundos
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Ajusta o Looger para Verbose para ter informações de debug
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Inicializa o tracker com o ID
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-52133417-2"];
}

- (void)customizeIphoneTheme
{
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    [navAppearance setTintColor:[UIColor whiteColor]];
    //[navAppearance setBarTintColor:[UIColor redColor]];
    
    [navAppearance setBarTintColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:200/255.0f alpha:1.0f]];
    [navAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                           [UIFont fontWithName:@"GillSans-Bold" size:18.0f], NSFontAttributeName,
                                           nil]];
    
    
    [[UILabel appearance] setTextColor:[UIColor grayColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ebenezersilva.Contas_Mensais" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ContasMensais" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ContasMensais.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
