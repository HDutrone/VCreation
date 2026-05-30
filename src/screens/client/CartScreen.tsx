import React from 'react';
import {
  View, Text, FlatList, Image, TouchableOpacity,
  StyleSheet, Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { CartItem } from '../../types';
import type { RootStackParamList } from '../../navigation/types';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function CartScreen() {
  const navigation = useNavigation<Nav>();
  const { state, removeFromCart, updateCartQty } = useApp();
  const items = state.cart;

  const total = items.reduce((sum, i) => sum + i.product.price * i.quantity, 0);
  const formatted = new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(total);

  const handleCheckout = () => {
    if (!state.user) {
      Alert.alert('Connexion requise', 'Veuillez vous connecter pour passer une commande.', [
        { text: 'Annuler', style: 'cancel' },
        { text: 'Se connecter', onPress: () => navigation.navigate('Login') },
      ]);
      return;
    }
    navigation.navigate('Payment');
  };

  if (items.length === 0) {
    return (
      <View style={styles.empty}>
        <Ionicons name="bag-outline" size={64} color={Colors.textMuted} />
        <Text style={styles.emptyTitle}>Votre panier est vide</Text>
        <Text style={styles.emptyDesc}>Explorez nos collections et ajoutez vos pièces favorites.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Panier</Text>
        <Text style={styles.count}>{items.length} article{items.length > 1 ? 's' : ''}</Text>
      </View>

      <FlatList
        data={items}
        keyExtractor={i => i.id}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ItemSeparatorComponent={() => <View style={{ height: 12 }} />}
        renderItem={({ item }) => <CartItemCard item={item} />}
        ListFooterComponent={
          <View style={styles.footer}>
            <GoldDivider />
            <View style={styles.totalRow}>
              <Text style={styles.totalLabel}>Total estimé</Text>
              <Text style={styles.totalAmount}>{formatted}</Text>
            </View>
            <View style={{ height: 16 }} />
            <GoldButton label="Procéder au paiement" onPress={handleCheckout} />
            <View style={{ height: 80 }} />
          </View>
        }
      />
    </View>
  );
}

function CartItemCard({ item }: { item: CartItem }) {
  const { removeFromCart, updateCartQty } = useApp();

  return (
    <View style={styles.card}>
      <Image source={{ uri: item.product.imageUrls[0] }} style={styles.img} />
      <View style={styles.cardBody}>
        <Text style={styles.cardName} numberOfLines={2}>{item.product.name}</Text>
        <Text style={styles.cardPrice}>
          {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(item.product.price)}
        </Text>
        <View style={styles.qtyRow}>
          <TouchableOpacity
            onPress={() => item.quantity > 1 ? updateCartQty(item.id, item.quantity - 1) : removeFromCart(item.id)}
            style={styles.qtyBtn}
          >
            <Ionicons name={item.quantity > 1 ? 'remove' : 'trash-outline'} size={16} color={Colors.gold} />
          </TouchableOpacity>
          <Text style={styles.qtyText}>{item.quantity}</Text>
          <TouchableOpacity onPress={() => updateCartQty(item.id, item.quantity + 1)} style={styles.qtyBtn}>
            <Ionicons name="add" size={16} color={Colors.gold} />
          </TouchableOpacity>
        </View>
      </View>
      <TouchableOpacity onPress={() => removeFromCart(item.id)} style={styles.deleteBtn}>
        <Ionicons name="close" size={18} color={Colors.textMuted} />
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: {
    paddingHorizontal: 20, paddingTop: 52, paddingBottom: 12,
  },
  title: { color: Colors.white, fontSize: 32, fontWeight: '700' },
  count: { color: Colors.textMuted, fontSize: 11, letterSpacing: 2, marginTop: 2 },
  list: { paddingHorizontal: 20, paddingTop: 8 },
  card: {
    flexDirection: 'row', backgroundColor: Colors.surface,
    borderRadius: 14, overflow: 'hidden',
    borderWidth: 1, borderColor: Colors.cardBorder,
  },
  img: { width: 100, height: 110, resizeMode: 'cover' },
  cardBody: { flex: 1, padding: 12, justifyContent: 'space-between' },
  cardName: { color: Colors.white, fontSize: 14, fontWeight: '600' },
  cardPrice: { color: Colors.gold, fontSize: 14, fontWeight: '700' },
  qtyRow: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  qtyBtn: {
    width: 30, height: 30, borderRadius: 8,
    borderWidth: 1, borderColor: Colors.cardBorder,
    alignItems: 'center', justifyContent: 'center',
  },
  qtyText: { color: Colors.white, fontSize: 14, fontWeight: '600', minWidth: 20, textAlign: 'center' },
  deleteBtn: { padding: 10 },
  footer: { paddingTop: 20 },
  totalRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingVertical: 16 },
  totalLabel: { color: Colors.textSecondary, fontSize: 14 },
  totalAmount: { color: Colors.gold, fontSize: 22, fontWeight: '700' },
  empty: { flex: 1, backgroundColor: Colors.background, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyTitle: { color: Colors.white, fontSize: 20, fontWeight: '700', marginTop: 20, marginBottom: 8 },
  emptyDesc: { color: Colors.textSecondary, fontSize: 14, textAlign: 'center', lineHeight: 22 },
});
