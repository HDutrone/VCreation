import React, { createContext, useContext, useReducer, ReactNode } from 'react';
import type { User, Product, CartItem, Order, OrderStatus, CustomRequest, CustomRequestStatus } from '../types';
import { PRODUCTS, ORDERS, CUSTOM_REQUESTS } from '../data/mock';

// ── State ──────────────────────────────────────────────────────────────
interface AppState {
  user: User | null;
  products: Product[];
  cart: CartItem[];
  orders: Order[];
  customRequests: CustomRequest[];
  authLoading: boolean;
  authError: string | null;
}

const initialState: AppState = {
  user: null,
  products: PRODUCTS,
  cart: [],
  orders: ORDERS,
  customRequests: CUSTOM_REQUESTS,
  authLoading: false,
  authError: null,
};

// ── Actions ────────────────────────────────────────────────────────────
type Action =
  | { type: 'AUTH_LOADING' }
  | { type: 'AUTH_SUCCESS'; user: User }
  | { type: 'AUTH_ERROR'; error: string }
  | { type: 'AUTH_CLEAR_ERROR' }
  | { type: 'LOGOUT' }
  | { type: 'TOGGLE_FAVORITE'; productId: string }
  | { type: 'TOGGLE_ACTIVE'; productId: string }
  | { type: 'ADD_TO_CART'; item: CartItem }
  | { type: 'REMOVE_FROM_CART'; itemId: string }
  | { type: 'UPDATE_CART_QTY'; itemId: string; qty: number }
  | { type: 'CLEAR_CART' }
  | { type: 'ADD_ORDER'; order: Order }
  | { type: 'UPDATE_ORDER_STATUS'; orderId: string; status: OrderStatus }
  | { type: 'ADD_CUSTOM_REQUEST'; request: CustomRequest }
  | { type: 'REPLY_REQUEST'; requestId: string; reply: string }
  | { type: 'UPDATE_REQUEST_STATUS'; requestId: string; status: CustomRequestStatus };

function reducer(state: AppState, action: Action): AppState {
  switch (action.type) {
    case 'AUTH_LOADING':
      return { ...state, authLoading: true, authError: null };
    case 'AUTH_SUCCESS':
      return { ...state, authLoading: false, user: action.user, authError: null };
    case 'AUTH_ERROR':
      return { ...state, authLoading: false, authError: action.error };
    case 'AUTH_CLEAR_ERROR':
      return { ...state, authError: null };
    case 'LOGOUT':
      return { ...state, user: null, cart: [] };
    case 'TOGGLE_FAVORITE':
      return {
        ...state,
        products: state.products.map(p =>
          p.id === action.productId ? { ...p, isFavorite: !p.isFavorite } : p
        ),
      };
    case 'TOGGLE_ACTIVE':
      return {
        ...state,
        products: state.products.map(p =>
          p.id === action.productId ? { ...p, isActive: !p.isActive } : p
        ),
      };
    case 'ADD_TO_CART':
      if (state.cart.some(i => i.product.id === action.item.product.id)) return state;
      return { ...state, cart: [...state.cart, action.item] };
    case 'REMOVE_FROM_CART':
      return { ...state, cart: state.cart.filter(i => i.id !== action.itemId) };
    case 'UPDATE_CART_QTY':
      return {
        ...state,
        cart: state.cart.map(i => i.id === action.itemId ? { ...i, quantity: action.qty } : i),
      };
    case 'CLEAR_CART':
      return { ...state, cart: [] };
    case 'ADD_ORDER':
      return { ...state, orders: [...state.orders, action.order] };
    case 'UPDATE_ORDER_STATUS':
      return {
        ...state,
        orders: state.orders.map(o => o.id === action.orderId ? { ...o, status: action.status } : o),
      };
    case 'ADD_CUSTOM_REQUEST':
      return { ...state, customRequests: [...state.customRequests, action.request] };
    case 'REPLY_REQUEST':
      return {
        ...state,
        customRequests: state.customRequests.map(r =>
          r.id === action.requestId ? { ...r, adminReply: action.reply, status: 'en_cours' as const } : r
        ),
      };
    case 'UPDATE_REQUEST_STATUS':
      return {
        ...state,
        customRequests: state.customRequests.map(r =>
          r.id === action.requestId ? { ...r, status: action.status } : r
        ),
      };
    default:
      return state;
  }
}

// ── Demo accounts ──────────────────────────────────────────────────────
const ACCOUNTS: Record<string, User> = {
  'amina@vcreations.cd': {
    id: 'u1', name: 'Amina Kabila', email: 'amina@vcreations.cd',
    phone: '+243810000001', role: 'client', memberSince: '2023', isPrivate: true,
  },
  'admin@vcreations.cd': {
    id: 'admin1', name: 'Admin VCréations', email: 'admin@vcreations.cd',
    phone: '+243810000000', role: 'admin', memberSince: '2022', isPrivate: false,
  },
};
const PASSWORDS: Record<string, string> = {
  'amina@vcreations.cd': 'client123',
  'admin@vcreations.cd': 'admin123',
};

// ── Context ────────────────────────────────────────────────────────────
interface AppContextType {
  state: AppState;
  login: (email: string, password: string) => Promise<boolean>;
  register: (name: string, email: string, password: string, phone?: string) => Promise<boolean>;
  logout: () => void;
  clearAuthError: () => void;
  toggleFavorite: (id: string) => void;
  toggleProductActive: (id: string) => void;
  addToCart: (item: CartItem) => void;
  removeFromCart: (id: string) => void;
  updateCartQty: (itemId: string, qty: number) => void;
  clearCart: () => void;
  addOrder: (order: Order) => void;
  updateOrderStatus: (orderId: string, status: OrderStatus) => void;
  addCustomRequest: (r: CustomRequest) => void;
  replyToRequest: (requestId: string, reply: string) => void;
  updateRequestStatus: (requestId: string, status: CustomRequestStatus) => void;
}

const AppContext = createContext<AppContextType | null>(null);

export function AppProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(reducer, initialState);

  const login = async (email: string, password: string): Promise<boolean> => {
    dispatch({ type: 'AUTH_LOADING' });
    await new Promise(r => setTimeout(r, 900));
    const acc = ACCOUNTS[email.toLowerCase().trim()];
    if (acc && PASSWORDS[email.toLowerCase().trim()] === password) {
      dispatch({ type: 'AUTH_SUCCESS', user: acc });
      return true;
    }
    dispatch({ type: 'AUTH_ERROR', error: 'Email ou mot de passe incorrect.' });
    return false;
  };

  const register = async (name: string, email: string, _pwd: string, phone?: string): Promise<boolean> => {
    dispatch({ type: 'AUTH_LOADING' });
    await new Promise(r => setTimeout(r, 900));
    if (ACCOUNTS[email.toLowerCase()]) {
      dispatch({ type: 'AUTH_ERROR', error: 'Un compte existe déjà avec cet email.' });
      return false;
    }
    dispatch({
      type: 'AUTH_SUCCESS',
      user: { id: `u${Date.now()}`, name, email, phone, role: 'client', memberSince: `${new Date().getFullYear()}`, isPrivate: false },
    });
    return true;
  };

  return (
    <AppContext.Provider value={{
      state,
      login,
      register,
      logout: () => dispatch({ type: 'LOGOUT' }),
      clearAuthError: () => dispatch({ type: 'AUTH_CLEAR_ERROR' }),
      toggleFavorite: (id) => dispatch({ type: 'TOGGLE_FAVORITE', productId: id }),
      toggleProductActive: (id) => dispatch({ type: 'TOGGLE_ACTIVE', productId: id }),
      addToCart: (item) => dispatch({ type: 'ADD_TO_CART', item }),
      removeFromCart: (id) => dispatch({ type: 'REMOVE_FROM_CART', itemId: id }),
      updateCartQty: (itemId, qty) => dispatch({ type: 'UPDATE_CART_QTY', itemId, qty }),
      clearCart: () => dispatch({ type: 'CLEAR_CART' }),
      addOrder: (order) => dispatch({ type: 'ADD_ORDER', order }),
      updateOrderStatus: (orderId, status) => dispatch({ type: 'UPDATE_ORDER_STATUS', orderId, status }),
      addCustomRequest: (r) => dispatch({ type: 'ADD_CUSTOM_REQUEST', request: r }),
      replyToRequest: (requestId, reply) => dispatch({ type: 'REPLY_REQUEST', requestId, reply }),
      updateRequestStatus: (requestId, status) => dispatch({ type: 'UPDATE_REQUEST_STATUS', requestId, status }),
    }}>
      {children}
    </AppContext.Provider>
  );
}

export const useApp = (): AppContextType => {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp must be used inside AppProvider');
  return ctx;
};
