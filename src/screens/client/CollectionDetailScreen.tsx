import React, { useState } from 'react';
import {
  View, Text, Image, ScrollView, TouchableOpacity,
  StyleSheet, FlatList, Dimensions, Alert,
} from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import { CATEGORY_LABELS, BADGE_LABELS } from '../../data/mock';
import type { RootStackParamList } from '../../navigation/types';

type Props = NativeStackScreenProps<RootStackParamList, 'CollectionDetail'>;
const { width } = Dimensions.get('window');

export default function CollectionDetailScreen({ route, navigation }: Props) {
  const { product } = route.params;
  const { state, toggleFavorite, addToCart } = useApp();
  const [selImg, setSelImg] = useState(0);

  const currentProduct = state.products.find(p => p.id === product.id) ?? product;
  const inCart = state.cart.some(i => i.product.id === product.id);

  const handleAddToCart = () => {
    if (!inCart) {
      addToCart({ id: `ci${Date.now()}`, product, quantity: 1, isSurMesure: false });
      Alert.alert('Ajouté', `${product.name} ajouté au panier.`);
    }
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backBtn}>
          <Ionicons name="chevron-back" size={22} color={Colors.white} />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>COLLECTIONS</Text>
        <TouchableOpacity onPress={() => toggleFavorite(product.id)} style={styles.favBtn}>
          <Ionicons
            name={currentProduct.isFavorite ? 'heart' : 'heart-outline'}
            size={20} color={currentProduct.isFavorite ? Colors.error : Colors.white}
          />
        </TouchableOpacity>
      </View>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Main image */}
        <View style={styles.mainImgWrap}>
          <Image source={{ uri: product.imageUrls[selImg] }} style={styles.mainImg} />
          <TouchableOpacity style={styles.fullscreenBtn}>
            <Ionicons name="expand-outline" size={14} color={Colors.white} />
            <Text style={styles.fullscreenText}> Plein écran</Text>
          </TouchableOpacity>
        </View>

        {/* Thumbnails */}
        {product.imageUrls.length > 1 && (
          <FlatList
            horizontal data={product.imageUrls} keyExtractor={(_, i) => String(i)}
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.thumbList}
            renderItem={({ item, index }) => (
              <TouchableOpacity onPress={() => setSelImg(index)}>
                <Image
                  source={{ uri: item }}
                  style={[styles.thumb, selImg === index && styles.thumbActive]}
                />
              </TouchableOpacity>
            )}
          />
        )}

        {/* Info */}
        <View style={styles.info}>
          <View style={styles.titleRow}>
            <View style={{ flex: 1 }}>
              <Text style={styles.productName}>{product.name}</Text>
              <Text style={styles.productCat}>{CATEGORY_LABELS[product.category]}</Text>
            </View>
            <View style={styles.badgeWrap}>
              <Text style={styles.badgeText}>{BADGE_LABELS[product.badge]}</Text>
            </View>
          </View>

          <View style={{ marginVertical: 16 }}>
            <GoldDivider />
          </View>

          <Text style={styles.description}>{product.description}</Text>

          <View style={styles.actions}>
            <View style={{ flex: 1 }}>
              <GoldButton
                label="Demander sur-mesure"
                onPress={() => navigation.navigate('ClientApp', { initialTab: 2 })}
              />
            </View>
            <TouchableOpacity
              onPress={handleAddToCart}
              style={[styles.addBtn, inCart && styles.addBtnActive]}
            >
              <Ionicons name={inCart ? 'checkmark' : 'add'} size={22} color={inCart ? Colors.gold : Colors.white} />
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingHorizontal: 12, paddingTop: 52, paddingBottom: 8,
  },
  backBtn: {
    width: 36, height: 36, borderRadius: 18, backgroundColor: Colors.surface,
    alignItems: 'center', justifyContent: 'center',
  },
  headerTitle: { color: Colors.white, fontSize: 12, letterSpacing: 4 },
  favBtn: {
    width: 36, height: 36, borderRadius: 18, backgroundColor: Colors.surface,
    alignItems: 'center', justifyContent: 'center',
  },
  mainImgWrap: {
    height: 380, marginHorizontal: 20, borderRadius: 16, overflow: 'hidden',
    backgroundColor: Colors.card,
  },
  mainImg: { width: '100%', height: '100%', resizeMode: 'cover' },
  fullscreenBtn: {
    position: 'absolute', top: 12, right: 12,
    flexDirection: 'row', alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.55)', borderRadius: 20,
    paddingHorizontal: 10, paddingVertical: 6,
  },
  fullscreenText: { color: Colors.white, fontSize: 11 },
  thumbList: { paddingHorizontal: 20, paddingVertical: 14, gap: 10 },
  thumb: { width: 72, height: 72, borderRadius: 8, resizeMode: 'cover', borderWidth: 1, borderColor: Colors.cardBorder },
  thumbActive: { borderColor: Colors.gold, borderWidth: 2 },
  info: { paddingHorizontal: 20, paddingBottom: 40 },
  titleRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12 },
  productName: { color: Colors.white, fontSize: 30, fontWeight: '700' },
  productCat: { color: Colors.textMuted, fontSize: 11, letterSpacing: 2, marginTop: 4 },
  badgeWrap: {
    borderWidth: 1, borderColor: Colors.cardBorder, borderRadius: 20,
    paddingHorizontal: 12, paddingVertical: 6, marginTop: 6,
  },
  badgeText: { color: Colors.textSecondary, fontSize: 12 },
  description: { color: Colors.textSecondary, fontSize: 14, lineHeight: 22 },
  actions: { flexDirection: 'row', gap: 12, marginTop: 28 },
  addBtn: {
    width: 54, height: 54, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, backgroundColor: 'transparent',
    alignItems: 'center', justifyContent: 'center',
  },
  addBtnActive: { borderColor: Colors.gold, backgroundColor: Colors.goldFaint },
});
