import React, { useState } from 'react';
import {
  View, Text, FlatList, Image, TouchableOpacity,
  StyleSheet, Switch, Dimensions, Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { useApp } from '../../context/AppContext';
import type { Product } from '../../types';

const { width } = Dimensions.get('window');
const CARD = (width - 54) / 2;

export default function ModelesScreen() {
  const { state, toggleProductActive } = useApp();
  const [filter, setFilter] = useState<'all' | 'active' | 'inactive'>('all');

  const products = state.products.filter(p => {
    if (filter === 'active') return p.isActive;
    if (filter === 'inactive') return !p.isActive;
    return true;
  });

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Modèles</Text>
        <TouchableOpacity style={styles.addBtn} onPress={() => Alert.alert('Bientôt', 'Ajout de modèle à venir.')}>
          <Ionicons name="add" size={22} color={Colors.gold} />
        </TouchableOpacity>
      </View>

      {/* Filter tabs */}
      <View style={styles.tabs}>
        {(['all', 'active', 'inactive'] as const).map(f => (
          <TouchableOpacity key={f} onPress={() => setFilter(f)} style={[styles.tab, filter === f && styles.tabActive]}>
            <Text style={[styles.tabText, filter === f && styles.tabTextActive]}>
              {f === 'all' ? 'Tous' : f === 'active' ? 'Actifs' : 'Inactifs'}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      <FlatList
        data={products}
        numColumns={2}
        keyExtractor={p => p.id}
        contentContainerStyle={styles.grid}
        columnWrapperStyle={{ gap: 14 }}
        showsVerticalScrollIndicator={false}
        renderItem={({ item }) => <ProductAdminCard product={item} onToggle={() => toggleProductActive(item.id)} />}
      />
    </View>
  );
}

function ProductAdminCard({ product, onToggle }: { product: Product; onToggle: () => void }) {
  return (
    <View style={[styles.card, { width: CARD }, !product.isActive && styles.cardInactive]}>
      <View style={styles.imgWrap}>
        <Image source={{ uri: product.imageUrls[0] }} style={styles.img} />
        {!product.isActive && (
          <View style={styles.inactiveMask}>
            <Text style={styles.inactiveLabel}>Masqué</Text>
          </View>
        )}
      </View>
      <Text style={styles.cardName} numberOfLines={1}>{product.name}</Text>
      <View style={styles.cardBottom}>
        <Text style={styles.cardViews}>{product.viewCount} vues</Text>
        <Switch
          value={product.isActive}
          onValueChange={onToggle}
          trackColor={{ false: Colors.cardBorder, true: Colors.gold + '66' }}
          thumbColor={product.isActive ? Colors.gold : Colors.textMuted}
          style={{ transform: [{ scale: 0.8 }] }}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
    paddingHorizontal: 20, paddingTop: 52, paddingBottom: 8,
  },
  title: { color: Colors.white, fontSize: 32, fontWeight: '700' },
  addBtn: {
    width: 40, height: 40, borderRadius: 20,
    backgroundColor: Colors.goldFaint, borderWidth: 1, borderColor: Colors.gold + '66',
    alignItems: 'center', justifyContent: 'center',
  },
  tabs: { flexDirection: 'row', paddingHorizontal: 20, gap: 10, marginBottom: 12 },
  tab: {
    paddingHorizontal: 16, paddingVertical: 7,
    borderRadius: 20, borderWidth: 1, borderColor: Colors.cardBorder,
  },
  tabActive: { backgroundColor: Colors.goldFaint, borderColor: Colors.gold },
  tabText: { color: Colors.textSecondary, fontSize: 12 },
  tabTextActive: { color: Colors.gold },
  grid: { paddingHorizontal: 20, paddingBottom: 100, gap: 20 },
  card: {},
  cardInactive: { opacity: 0.6 },
  imgWrap: { height: CARD * 1.3, borderRadius: 12, overflow: 'hidden', backgroundColor: Colors.card, marginBottom: 8 },
  img: { width: '100%', height: '100%', resizeMode: 'cover' },
  inactiveMask: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.55)',
    alignItems: 'center', justifyContent: 'center',
  },
  inactiveLabel: { color: Colors.white, fontSize: 12, fontWeight: '700', letterSpacing: 1 },
  cardName: { color: Colors.white, fontSize: 13, fontWeight: '600', marginBottom: 6 },
  cardBottom: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  cardViews: { color: Colors.textMuted, fontSize: 11 },
});
