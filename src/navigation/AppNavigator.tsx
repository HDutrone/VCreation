import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Colors } from '../constants/Colors';
import type { RootStackParamList } from './types';

import SplashScreen from '../screens/SplashScreen';
import LoginScreen from '../screens/auth/LoginScreen';
import RegisterScreen from '../screens/auth/RegisterScreen';
import { ClientNavigator } from './ClientNavigator';
import { AdminNavigator } from './AdminNavigator';
import CollectionDetailScreen from '../screens/client/CollectionDetailScreen';
import PaymentScreen from '../screens/client/PaymentScreen';
import ConfirmationScreen from '../screens/client/ConfirmationScreen';
import OrdersScreen from '../screens/client/OrdersScreen';
import TrackingScreen from '../screens/client/TrackingScreen';
import FavoritesScreen from '../screens/client/FavoritesScreen';

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator
        screenOptions={{
          headerShown: false,
          contentStyle: { backgroundColor: Colors.background },
          animation: 'fade',
        }}
      >
        <Stack.Screen name="Splash" component={SplashScreen} />
        <Stack.Screen name="Login" component={LoginScreen} />
        <Stack.Screen name="Register" component={RegisterScreen} />
        <Stack.Screen name="ClientApp" component={ClientNavigator} />
        <Stack.Screen name="AdminApp" component={AdminNavigator} />
        <Stack.Screen name="CollectionDetail" component={CollectionDetailScreen} options={{ animation: 'slide_from_right' }} />
        <Stack.Screen name="Payment" component={PaymentScreen} options={{ animation: 'slide_from_bottom' }} />
        <Stack.Screen name="Confirmation" component={ConfirmationScreen} options={{ animation: 'fade' }} />
        <Stack.Screen name="Orders" component={OrdersScreen} options={{ animation: 'slide_from_right' }} />
        <Stack.Screen name="Tracking" component={TrackingScreen} options={{ animation: 'slide_from_right' }} />
        <Stack.Screen name="Favorites" component={FavoritesScreen} options={{ animation: 'slide_from_right' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
