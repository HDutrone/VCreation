import type { Product, Order, CustomRequest } from '../types';

export const PRODUCTS: Product[] = [
  {
    id: 'p1', name: 'Nuit Étoilée', subtitle: 'Robe Haute Couture',
    description: 'Création en franges noires superposées, travail artisanal minutieux réalisé entièrement à la main. Inspirée du jazz de l\'ère Art Déco, cette pièce unique allie élégance structurée et mouvement perpétuel.',
    category: 'robe', badge: 'pieceSignature', price: 1800,
    imageUrls: ['https://picsum.photos/seed/nuit1/800/1000', 'https://picsum.photos/seed/nuit2/800/1000'],
    viewCount: 86, isActive: true, isFavorite: false,
  },
  {
    id: 'p2', name: 'Lagon Bleu', subtitle: 'Kaftan Haute Couture',
    description: 'Kaftan fluide à imprimé aquarelle, façonné dans un satin de soie premium. Trois vues pour révéler son amplitude en mouvement.',
    category: 'kaftan', badge: 'surMesureDispo', price: 1200,
    imageUrls: ['https://picsum.photos/seed/lagon1/800/1000', 'https://picsum.photos/seed/lagon2/800/1000', 'https://picsum.photos/seed/lagon3/800/1000'],
    viewCount: 98, isActive: true, isFavorite: false,
  },
  {
    id: 'p3', name: 'Soleil Rouge', subtitle: 'Robe Haute Couture',
    description: 'Robe soleil aux teintes enflammées, taillée dans une mousseline légère aux reflets iridescents. Une silhouette libre qui célèbre la femme dans toute sa splendeur.',
    category: 'robe', badge: 'pieceSignature', price: 2100,
    imageUrls: ['https://picsum.photos/seed/soleil1/800/1000'],
    viewCount: 64, isActive: true, isFavorite: false,
  },
  {
    id: 'p4', name: 'Harmonie', subtitle: 'Kaftan Haute Couture',
    description: 'Collection trio de kaftans en soieries imprimées. Trois silhouettes, trois récits, une harmonie parfaite. Disponible en ensemble ou en pièce individuelle.',
    category: 'kaftan', badge: 'surMesureDispo', price: 950,
    imageUrls: ['https://picsum.photos/seed/harmonie1/800/1000'],
    viewCount: 42, isActive: true, isFavorite: false,
  },
  {
    id: 'p5', name: 'Aube Dorée', subtitle: 'Tailleur Haute Couture',
    description: 'Tailleur structuré en brocart doré, lignes épurées et finitions couture. La quintessence du style corporate d\'exception.',
    category: 'tailleur', badge: 'nouveaute', price: 1500,
    imageUrls: ['https://picsum.photos/seed/aube1/800/1000', 'https://picsum.photos/seed/aube2/800/1000'],
    viewCount: 23, isActive: true, isFavorite: false,
  },
];

const P1 = PRODUCTS[0];
const P2 = PRODUCTS[1];
const P3 = PRODUCTS[2];

export const ORDERS: Order[] = [
  {
    id: 'o1', clientName: 'Amina Kabila',
    items: [{ id: 'ci1', product: P1, quantity: 1, isSurMesure: false }],
    total: P1.price, status: 'en_preparation', paymentMethod: 'mpesa', placedAt: 'il y a 2h',
  },
  {
    id: 'o2', clientName: 'Chiara Moretti',
    items: [{ id: 'ci2', product: P2, quantity: 1, isSurMesure: false }],
    total: P2.price, status: 'confirmée', paymentMethod: 'orange', placedAt: 'il y a 5h',
  },
  {
    id: 'o3', clientName: 'Marie Ngozi',
    items: [{ id: 'ci3', product: P3, quantity: 1, isSurMesure: false }],
    total: P3.price, status: 'livrée', paymentMethod: 'card', placedAt: '18 jan.',
  },
];

export const CUSTOM_REQUESTS: CustomRequest[] = [
  {
    id: 'cr1', clientName: 'Chiara Moretti', garmentType: 'Robe de soirée', occasion: 'Gala',
    delai: '3 mois', message: 'Je recherche une robe longue pour un gala d\'ambassade. Je préfère les tons noir et or avec des détails brodés.',
    receivedAt: 'il y a 5h', status: 'nouvelle',
  },
  {
    id: 'cr2', clientName: 'Amina Kabila', garmentType: 'Kaftan', occasion: 'Mariage',
    delai: '2 mois', message: 'Kaftan pour mariage traditionnel, coloris ivoire et doré.',
    receivedAt: 'il y a 2j', status: 'en_cours',
  },
  {
    id: 'cr3', clientName: 'Marie Ngozi', garmentType: 'Tailleur', occasion: 'Corporate',
    delai: '1 mois', message: 'Tailleur strict pour réunion d\'affaires internationale.',
    receivedAt: '10 jan.', status: 'devis_envoyé',
  },
];

export const BADGE_LABELS: Record<string, string> = {
  pieceSignature: 'Pièce signature',
  surMesureDispo: 'Sur-mesure dispo.',
  nouveaute:      'Nouveauté',
};

export const CATEGORY_LABELS: Record<string, string> = {
  robe:     'ROBE HAUTE COUTURE',
  kaftan:   'KAFTAN HAUTE COUTURE',
  tailleur: 'TAILLEUR HAUTE COUTURE',
  ensemble: 'ENSEMBLE HAUTE COUTURE',
};
