import type { Product } from '../types';

export type RootStackParamList = {
  Splash: undefined;
  Login: undefined;
  Register: undefined;
  ClientApp: { initialTab?: number };
  AdminApp: undefined;
  CollectionDetail: { product: Product };
  Payment: undefined;
  Confirmation: { orderId: string };
  Orders: undefined;
  Tracking: { orderId: string };
  Favorites: undefined;
};

export type ClientTabParamList = {
  Home: undefined;
  Collections: undefined;
  SurMesure: undefined;
  Cart: undefined;
  Profile: undefined;
};

export type AdminTabParamList = {
  Dashboard: undefined;
  Modeles: undefined;
  Commandes: undefined;
  SurMesureAdmin: undefined;
  Clients: undefined;
};
