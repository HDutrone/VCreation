import React from 'react';
import {
  View, Text, FlatList, TouchableOpacity, StyleSheet,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Colors } from '../../constants/Colors';
import { StatusBadge } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { Order } from '../../types';
import type { RootStackParamList } from '../../navigation/types';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function OrdersScreen() {
  const navigation = useNavigation<Nav>();
  const { state } = useApp();
  const orders = [...state.orders].reverse();

  if (orders.length === 0) {
    return (
      <View style={styles.empty}>
        <Ionicons name="receipt-outline" size={64} color={Colors.textMuted} />
        <Text style={styles.emptyTitle}>Aucune commande</Text>
        <Text style={styles.emptyDesc}>Vos commandes apparaîtront ici une fois passées.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Mes commandes</Text>
        <Text style={styles.count}>{orders.length} commande{orders.length > 1 ? 's' : ''}</Text>
      </View>

      <FlatList
        data={orders}
        keyExtractor={o => o.id}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ItemSeparatorComponent={() => <View style={{ height: 12 }} />}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={styles.card}
            onPress={() => navigation.navigate('Tracking', { orderId: item.id })}
            activeOpacity={0.85}
          >
            <View style={styles.cardTop}>
              <View>
                <Text style={styles.cardId}>#{item.id}</Text>
                <Text style={styles.cardDate}>{item.placedAt}</Text>
              </View>
              <StatusBadge status={item.status} />
            </View>
            <View style={styles.cardBottom}>
              <Text style={styles.cardItems}>
                {item.items.length} article{item.items.length > 1 ? 's' : ''}
              </Text>
              <Text style={styles.cardTotal}>
                {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(item.total)}
              </Text>
            </View>
            <View style={styles.cardArrow}>
              <Ionicons name="chevron-forward" size={16} color={Colors.textMuted} />
            </View>
          </TouchableOpacity>
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
  list: { paddingHorizontal: 20, paddingTop: 8, paddingBottom: 80 },
  card: {
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, padding: 16,
  },
  cardTop: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 },
  cardId: { color: Colors.white, fontSize: 14, fontWeight: '700' },
  cardDate: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
  cardBottom: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  cardItems: { color: Colors.textSecondary, fontSize: 13 },
  cardTotal: { color: Colors.gold, fontSize: 16, fontWeight: '700' },
  cardArrow: { position: 'absolute', right: 16, top: '50%' },
  empty: { flex: 1, backgroundColor: Colors.background, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyTitle: { color: Colors.white, fontSize: 20, fontWeight: '700', marginTop: 20, marginBottom: 8 },
  emptyDesc: { color: Colors.textSecondary, fontSize: 14, textAlign: 'center', lineHeight: 22 },
});
