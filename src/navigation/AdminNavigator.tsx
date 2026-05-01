import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/Colors';
import type { AdminTabParamList } from './types';

import DashboardScreen from '../screens/admin/DashboardScreen';
import ModelesScreen from '../screens/admin/ModelesScreen';
import CommandesScreen from '../screens/admin/CommandesScreen';
import SurMesureAdminScreen from '../screens/admin/SurMesureAdminScreen';
import ClientsScreen from '../screens/admin/ClientsScreen';

const Tab = createBottomTabNavigator<AdminTabParamList>();

export function AdminNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
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
          const map: Record<string, keyof typeof Ionicons.glyphMap> = {
            Dashboard: color === Colors.gold ? 'grid' : 'grid-outline',
            Modeles: color === Colors.gold ? 'shirt' : 'shirt-outline',
            Commandes: color === Colors.gold ? 'bag' : 'bag-outline',
            SurMesureAdmin: color === Colors.gold ? 'water' : 'water-outline',
            Clients: color === Colors.gold ? 'people' : 'people-outline',
          };
          return <Ionicons name={map[route.name]} size={size} color={color} />;
        },
      })}
    >
      <Tab.Screen name="Dashboard" component={DashboardScreen} options={{ tabBarLabel: 'Dashboard' }} />
      <Tab.Screen name="Modeles" component={ModelesScreen} options={{ tabBarLabel: 'Modèles' }} />
      <Tab.Screen name="Commandes" component={CommandesScreen} />
      <Tab.Screen name="SurMesureAdmin" component={SurMesureAdminScreen} options={{ tabBarLabel: 'Sur-Mesure' }} />
      <Tab.Screen name="Clients" component={ClientsScreen} />
    </Tab.Navigator>
  );
}
