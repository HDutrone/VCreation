import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/Colors';
import type { ClientTabParamList } from './types';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from './types';

import HomeScreen from '../screens/client/HomeScreen';
import CollectionsScreen from '../screens/client/CollectionsScreen';
import SurMesureScreen from '../screens/client/SurMesureScreen';
import CartScreen from '../screens/client/CartScreen';
import ProfileScreen from '../screens/client/ProfileScreen';

const Tab = createBottomTabNavigator<ClientTabParamList>();

type Props = NativeStackScreenProps<RootStackParamList, 'ClientApp'>;

export function ClientNavigator({ route }: Props) {
  const initialTab = route.params?.initialTab ?? 0;
  const tabNames: (keyof ClientTabParamList)[] = ['Home', 'Collections', 'SurMesure', 'Cart', 'Profile'];

  return (
    <Tab.Navigator
      initialRouteName={tabNames[initialTab]}
      screenOptions={({ route: r }) => ({
        headerShown: false,
        tabBarStyle: {
          backgroundColor: Colors.background,
          borderTopColor: Colors.divider,
          borderTopWidth: 0.5,
          height: 64,
          paddingBottom: 10,
        },
        tabBarActiveTintColor: Colors.gold,
        tabBarInactiveTintColor: Colors.textMuted,
        tabBarLabelStyle: { fontSize: 10, fontWeight: '500' },
        tabBarIcon: ({ color, size }) => {
          const icons: Record<string, keyof typeof Ionicons.glyphMap> = {
            Home: 'home',
            Collections: 'grid',
            SurMesure: 'water',
            Cart: 'bag',
            Profile: 'person',
          };
          const outlines: Record<string, keyof typeof Ionicons.glyphMap> = {
            Home: 'home-outline',
            Collections: 'grid-outline',
            SurMesure: 'water-outline',
            Cart: 'bag-outline',
            Profile: 'person-outline',
          };
          const isFocused = tabNames[tabNames.indexOf(r.name as keyof ClientTabParamList)];
          const iconName = color === Colors.gold ? icons[r.name] : outlines[r.name];
          return <Ionicons name={iconName} size={size} color={color} />;
        },
      })}
    >
      <Tab.Screen name="Home" component={HomeScreen} options={{ tabBarLabel: 'Accueil' }} />
      <Tab.Screen name="Collections" component={CollectionsScreen} />
      <Tab.Screen name="SurMesure" component={SurMesureScreen} options={{ tabBarLabel: 'Sur-Mesure' }} />
      <Tab.Screen name="Cart" component={CartScreen} options={{ tabBarLabel: 'Panier' }} />
      <Tab.Screen name="Profile" component={ProfileScreen} options={{ tabBarLabel: 'Profil' }} />
    </Tab.Navigator>
  );
}
