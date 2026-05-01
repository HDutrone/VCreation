// ── User ──────────────────────────────────────────────────────────────
export type UserRole = 'guest' | 'client' | 'admin';

export interface User {
  id: string;
  name: string;
  email: string;
  phone?: string;
  role: UserRole;
  memberSince: string;
  isPrivate: boolean;
}

// ── Product ────────────────────────────────────────────────────────────
export type ProductCategory = 'robe' | 'kaftan' | 'tailleur' | 'ensemble';
export type ProductBadge    = 'pieceSignature' | 'surMesureDispo' | 'nouveaute';

export interface Product {
  id: string;
  name: string;
  subtitle: string;
  description: string;
  category: ProductCategory;
  badge: ProductBadge;
  imageUrls: string[];
  price: number;
  viewCount: number;
  isActive: boolean;
  isFavorite: boolean;
}

// ── Cart ───────────────────────────────────────────────────────────────
export interface CartItem {
  id: string;
  product: Product;
  quantity: number;
  isSurMesure: boolean;
}

// ── Orders ─────────────────────────────────────────────────────────────
export type OrderStatus = 'confirmée' | 'en_preparation' | 'en_livraison' | 'livrée' | 'annulée';

export interface Order {
  id: string;
  clientName: string;
  items: CartItem[];
  total: number;
  status: OrderStatus;
  paymentMethod?: string;
  placedAt: string;
}

// ── Custom Request ─────────────────────────────────────────────────────
export type CustomRequestStatus = 'nouvelle' | 'en_cours' | 'devis_envoyé' | 'acceptée' | 'refusée';

export interface CustomRequest {
  id: string;
  clientName: string;
  garmentType: string;
  occasion: string;
  delai: string;
  message: string;
  receivedAt: string;
  status: CustomRequestStatus;
  adminReply?: string;
}
