import React from 'react';
import {
  View, Text, FlatList, Image, TouchableOpacity, StyleSheet, Dimensions,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Colors } from '../../constants/Colors';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';

type Nav = NativeStackNavigationProp<RootStackParamList>;
const { width } = Dimensions.get('window');
const CARD = (width - 54) / 2;

export default function FavoritesScreen() {
  const navigation = useNavigation<Nav>();
  const { state, toggleFavorite } = useApp();
  const favorites = state.products.filter(p => p.isFavorite);

  if (favorites.length === 0) {
    return (
      <View style={styles.empty}>
        <Ionicons name="heart-outline" size={64} color={Colors.textMuted} />
        <Text style={styles.emptyTitle}>Aucun favori</Text>
        <Text style={styles.emptyDesc}>Appuyez sur le cœur d'une création pour l'ajouter ici.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Favoris</Text>
        <Text style={styles.count}>{favorites.length} pièce{favorites.length > 1 ? 's' : ''}</Text>
      </View>

      <FlatList
        data={favorites}
        numColumns={2}
        keyExtractor={p => p.id}
        contentContainerStyle={styles.grid}
        columnWrapperStyle={{ gap: 14 }}
        showsVerticalScrollIndicator={false}
        renderItem={({ item }) => (
          <View style={[styles.card, { width: CARD }]}>
            <TouchableOpacity
              onPress={() => navigation.navigate('CollectionDetail', { product: item })}
              activeOpacity={0.85}
            >
              <View style={styles.imgWrap}>
                <Image source={{ uri: item.imageUrls[0] }} style={styles.img} />
              </View>
              <Text style={styles.cardName} numberOfLines={2}>{item.name}</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => toggleFavorite(item.id)} style={styles.heartBtn}>
              <Ionicons name="heart" size={20} color={Colors.error} />
            </TouchableOpacity>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingTop: 52, paddingBottom: 12 },
  title: { color: Colors.white, fontSize: 32, fontWeight: '700' },
  count: { color: Colors.textMuted, fontSize: 11, letterSpacing: 2, marginTop: 2 },
  grid: { paddingHorizontal: 20, paddingTop: 8, paddingBottom: 100, gap: 20 },
  card: {},
  imgWrap: {
    height: CARD * 1.35, borderRadius: 12, overflow: 'hidden',
    backgroundColor: Colors.card, marginBottom: 8,
  },
  img: { width: '100%', height: '100%', resizeMode: 'cover' },
  cardName: { color: Colors.white, fontSize: 13, fontWeight: '600' },
  heartBtn: { position: 'absolute', top: 10, right: 10 },
  empty: { flex: 1, backgroundColor: Colors.background, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyTitle: { color: Colors.white, fontSize: 20, fontWeight: '700', marginTop: 20, marginBottom: 8 },
  emptyDesc: { color: Colors.textSecondary, fontSize: 14, textAlign: 'center', lineHeight: 22 },
});
