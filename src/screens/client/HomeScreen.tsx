import React, { useState } from 'react';
import {
  View, Text, ScrollView, Image, TouchableOpacity,
  FlatList, StyleSheet, Dimensions,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Colors } from '../../constants/Colors';
import { LogoSmall } from '../../components/Logo';
import { WhatsAppBanner } from '../../components/WhatsAppFab';
import { GoldDivider } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';
import type { Product, ProductCategory } from '../../types';

type Nav = NativeStackNavigationProp<RootStackParamList>;
const { width } = Dimensions.get('window');
const CARD_W = (width - 54) / 2;

const FILTERS: { label: string; value: ProductCategory | null }[] = [
  { label: 'Tous', value: null },
  { label: 'Soirée', value: 'robe' },
  { label: 'Kaftan', value: 'kaftan' },
  { label: 'Sur-mesure', value: 'ensemble' },
];

export default function HomeScreen() {
  const navigation = useNavigation<Nav>();
  const { state } = useApp();
  const [filter, setFilter] = useState<ProductCategory | null>(null);

  const active = state.products.filter(p => p.isActive);
  const filtered = filter ? active.filter(p => p.category === filter) : active;

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Header */}
      <View style={styles.header}>
        <LogoSmall height={34} />
        <View style={styles.headerRight}>
          <Ionicons name="search-outline" size={22} color={Colors.white} />
          <TouchableOpacity onPress={() => navigation.navigate('Login')} style={styles.avatar}>
            <Text style={styles.avatarText}>
              {state.user ? state.user.name[0].toUpperCase() : '?'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Hero */}
      {active[0] && (
        <TouchableOpacity
          onPress={() => navigation.navigate('CollectionDetail', { product: active[0] })}
          style={styles.hero} activeOpacity={0.9}
        >
          <Image source={{ uri: active[0].imageUrls[0] }} style={styles.heroImg} />
          <View style={styles.heroOverlay} />
          <View style={styles.newBadge}><Text style={styles.newBadgeText}>Nouveauté</Text></View>
          <View style={styles.heroText}>
            <Text style={styles.heroLabel}>NOUVELLE COLLECTION</Text>
            <Text style={styles.heroTitle}>{active[0].name}</Text>
          </View>
        </TouchableOpacity>
      )}

      {/* Category filter */}
      <FlatList
        horizontal data={FILTERS} keyExtractor={i => i.label}
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.filterList}
        renderItem={({ item }) => {
          const sel = filter === item.value;
          return (
            <TouchableOpacity
              onPress={() => setFilter(item.value)}
              style={[styles.chip, sel && styles.chipActive]}
            >
              <Text style={[styles.chipText, sel && styles.chipTextActive]}>{item.label}</Text>
            </TouchableOpacity>
          );
        }}
      />

      {/* Dot divider */}
      <View style={styles.dotRow}>
        <View style={styles.dotLine} />
        <View style={styles.dot} />
        <View style={styles.dotLine} />
      </View>

      {/* Featured */}
      <View style={styles.sectionHeader}>
        <Text style={styles.sectionTitle}>Créations vedettes</Text>
        <Text style={styles.seeAll}>Voir tout ›</Text>
      </View>

      <View style={styles.grid}>
        {filtered.slice(0, 4).map(p => (
          <ProductCard key={p.id} product={p} onPress={() => navigation.navigate('CollectionDetail', { product: p })} />
        ))}
      </View>

      <WhatsAppBanner />
      <View style={{ height: 32 }} />
    </ScrollView>
  );
}

function ProductCard({ product, onPress }: { product: Product; onPress: () => void }) {
  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.85} style={[styles.card, { width: CARD_W }]}>
      <View style={styles.cardImg}>
        <Image source={{ uri: product.imageUrls[0] }} style={StyleSheet.absoluteFill} />
        <View style={styles.galerieBadge}>
          <Ionicons name="grid-outline" size={9} color={Colors.white} />
          <Text style={styles.galerieText}>Galerie</Text>
        </View>
        <Text style={styles.vueCount}>{product.viewCount} vues</Text>
      </View>
      <Text style={styles.cardName}>{product.name}</Text>
      <View style={[styles.cardBadge, product.badge === 'pieceSignature' && styles.cardBadgeGold]}>
        <Text style={[styles.cardBadgeText, product.badge === 'pieceSignature' && { color: Colors.gold }]}>
          {product.badge === 'pieceSignature' ? 'Pièce signature' : 'Sur-mesure dispo.'}
        </Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
    paddingHorizontal: 20, paddingTop: 52, paddingBottom: 12,
    backgroundColor: Colors.background,
  },
  headerRight: { flexDirection: 'row', alignItems: 'center', gap: 14 },
  avatar: {
    width: 34, height: 34, borderRadius: 17,
    borderWidth: 1.5, borderColor: Colors.gold,
    backgroundColor: Colors.goldFaint, alignItems: 'center', justifyContent: 'center',
  },
  avatarText: { color: Colors.gold, fontSize: 13, fontWeight: '700' },
  hero: {
    height: 280, marginHorizontal: 20, borderRadius: 16, overflow: 'hidden', marginBottom: 16,
  },
  heroImg: { ...StyleSheet.absoluteFillObject, resizeMode: 'cover' },
  heroOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'transparent',
    // gradient simulated via bottom shadow
  },
  newBadge: {
    position: 'absolute', top: 14, right: 14,
    backgroundColor: 'rgba(0,0,0,0.55)', borderRadius: 20,
    paddingHorizontal: 10, paddingVertical: 5,
  },
  newBadgeText: { color: Colors.white, fontSize: 11 },
  heroText: { position: 'absolute', left: 16, bottom: 16 },
  heroLabel: { color: Colors.textSecondary, fontSize: 10, letterSpacing: 2 },
  heroTitle: { color: Colors.white, fontSize: 22, fontWeight: '700', marginTop: 4 },
  filterList: { paddingHorizontal: 20, gap: 10, paddingBottom: 4 },
  chip: {
    paddingHorizontal: 18, paddingVertical: 8,
    borderRadius: 20, borderWidth: 1, borderColor: Colors.cardBorder,
  },
  chipActive: { backgroundColor: Colors.goldFaint, borderColor: Colors.gold },
  chipText: { color: Colors.textSecondary, fontSize: 13 },
  chipTextActive: { color: Colors.gold, fontWeight: '600' },
  dotRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginVertical: 20 },
  dotLine: { width: 60, height: 0.5, backgroundColor: Colors.divider },
  dot: { width: 6, height: 6, borderRadius: 3, backgroundColor: Colors.gold, marginHorizontal: 8 },
  sectionHeader: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
    paddingHorizontal: 20, marginBottom: 12,
  },
  sectionTitle: { color: Colors.white, fontSize: 18, fontWeight: '700' },
  seeAll: { color: Colors.textSecondary, fontSize: 13 },
  grid: {
    flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 20, gap: 14, marginBottom: 24,
  },
  card: { marginBottom: 6 },
  cardImg: {
    height: CARD_W * 1.35, borderRadius: 12, overflow: 'hidden',
    backgroundColor: Colors.card, marginBottom: 8,
  },
  galerieBadge: {
    position: 'absolute', top: 10, right: 10,
    flexDirection: 'row', alignItems: 'center', gap: 4,
    backgroundColor: 'rgba(0,0,0,0.55)', borderRadius: 6,
    paddingHorizontal: 8, paddingVertical: 4,
  },
  galerieText: { color: Colors.white, fontSize: 10 },
  vueCount: { position: 'absolute', left: 10, bottom: 10, color: Colors.white, fontSize: 10 },
  cardName: { color: Colors.white, fontSize: 14, fontWeight: '600', marginBottom: 6 },
  cardBadge: {
    alignSelf: 'flex-start', paddingHorizontal: 10, paddingVertical: 4,
    borderRadius: 20, borderWidth: 1, borderColor: Colors.cardBorder, backgroundColor: Colors.surface,
  },
  cardBadgeGold: { backgroundColor: Colors.goldFaint, borderColor: Colors.gold + '66' },
  cardBadgeText: { color: Colors.textSecondary, fontSize: 11 },
});
