import React, { useState } from 'react';
import {
  View, Text, FlatList, Image, TouchableOpacity, StyleSheet, Dimensions,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Colors } from '../../constants/Colors';
import { useApp } from '../../context/AppContext';
import type { Product, ProductCategory } from '../../types';
import type { RootStackParamList } from '../../navigation/types';

type Nav = NativeStackNavigationProp<RootStackParamList>;
const { width } = Dimensions.get('window');
const CARD = (width - 54) / 2;

export default function CollectionsScreen() {
  const navigation = useNavigation<Nav>();
  const { state } = useApp();
  const [filter, setFilter] = useState<ProductCategory | null>(null);

  const active = state.products.filter(p => p.isActive);
  const filtered = filter ? active.filter(p => p.category === filter) : active;

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.title}>Collections</Text>
          <Text style={styles.count}>{active.length} CRÉATIONS</Text>
        </View>
        <TouchableOpacity
          style={styles.filterBtn}
          onPress={() => setFilter(null)}
        >
          <Text style={styles.filterText}>{filter ? filter.toUpperCase() : 'Filtrer'} ›</Text>
        </TouchableOpacity>
      </View>

      {/* Category pills */}
      <FlatList
        horizontal data={[null, 'robe', 'kaftan', 'tailleur', 'ensemble'] as (ProductCategory | null)[]}
        keyExtractor={(i) => i ?? 'all'} showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.pills}
        renderItem={({ item }) => {
          const label = item === null ? 'Toutes' : item.charAt(0).toUpperCase() + item.slice(1) + 's';
          const sel = filter === item;
          return (
            <TouchableOpacity onPress={() => setFilter(item)} style={[styles.pill, sel && styles.pillActive]}>
              <Text style={[styles.pillText, sel && { color: Colors.gold }]}>{label}</Text>
            </TouchableOpacity>
          );
        }}
      />

      {/* Dot separator */}
      <View style={styles.dotRow}>
        <View style={styles.dotLine} />
        <View style={styles.dot} />
        <View style={styles.dotLine} />
      </View>

      <FlatList
        data={filtered} numColumns={2}
        keyExtractor={p => p.id}
        contentContainerStyle={styles.grid}
        columnWrapperStyle={{ gap: 14 }}
        showsVerticalScrollIndicator={false}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.card, { width: CARD }]}
            onPress={() => navigation.navigate('CollectionDetail', { product: item })}
            activeOpacity={0.85}
          >
            <View style={styles.imgWrap}>
              <Image source={{ uri: item.imageUrls[0] }} style={styles.img} />
              <View style={styles.galerieBadge}>
                <Ionicons name="grid-outline" size={9} color={Colors.white} />
                <Text style={styles.galerieText}> Galerie</Text>
              </View>
              <Text style={styles.vues}>{item.viewCount} vues</Text>
            </View>
            <Text style={styles.cardName}>{item.name}</Text>
            <View style={[styles.badge, item.badge === 'pieceSignature' && styles.badgeGold]}>
              <Text style={[styles.badgeText, item.badge === 'pieceSignature' && { color: Colors.gold }]}>
                {item.badge === 'pieceSignature' ? 'Pièce signature' : 'Sur-mesure dispo.'}
              </Text>
            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start',
    paddingHorizontal: 20, paddingTop: 52, paddingBottom: 8,
  },
  title: { color: Colors.white, fontSize: 32, fontWeight: '700' },
  count: { color: Colors.textMuted, fontSize: 11, letterSpacing: 2, marginTop: 2 },
  filterBtn: {
    borderWidth: 1, borderColor: Colors.cardBorder, borderRadius: 20,
    paddingHorizontal: 14, paddingVertical: 6, marginTop: 10,
  },
  filterText: { color: Colors.textSecondary, fontSize: 13 },
  pills: { paddingHorizontal: 20, gap: 10, paddingBottom: 8, paddingTop: 4 },
  pill: { paddingHorizontal: 14, paddingVertical: 7, borderRadius: 20, borderWidth: 1, borderColor: Colors.cardBorder },
  pillActive: { backgroundColor: Colors.goldFaint, borderColor: Colors.gold },
  pillText: { color: Colors.textSecondary, fontSize: 12 },
  dotRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginVertical: 12 },
  dotLine: { width: 80, height: 0.5, backgroundColor: Colors.divider },
  dot: { width: 6, height: 6, borderRadius: 3, backgroundColor: Colors.gold, marginHorizontal: 8 },
  grid: { paddingHorizontal: 20, paddingBottom: 100, gap: 20 },
  card: {},
  imgWrap: {
    height: CARD * 1.35, borderRadius: 12, overflow: 'hidden',
    backgroundColor: Colors.card, marginBottom: 8,
  },
  img: { width: '100%', height: '100%', resizeMode: 'cover' },
  galerieBadge: {
    position: 'absolute', top: 10, right: 10,
    flexDirection: 'row', alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.55)', borderRadius: 6,
    paddingHorizontal: 7, paddingVertical: 4,
  },
  galerieText: { color: Colors.white, fontSize: 10 },
  vues: { position: 'absolute', left: 10, bottom: 10, color: Colors.white, fontSize: 10 },
  cardName: { color: Colors.white, fontSize: 14, fontWeight: '600', marginBottom: 6 },
  badge: {
    alignSelf: 'flex-start', paddingHorizontal: 10, paddingVertical: 4,
    borderRadius: 20, borderWidth: 1, borderColor: Colors.cardBorder, backgroundColor: Colors.surface,
  },
  badgeGold: { backgroundColor: Colors.goldFaint, borderColor: Colors.gold + '66' },
  badgeText: { color: Colors.textSecondary, fontSize: 11 },
});
