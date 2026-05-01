import React, { useState } from 'react';
import {
  View, Text, FlatList, TouchableOpacity, StyleSheet, Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { StatusBadge } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { Order } from '../../types';

type OrderStatus = Order['status'];
const STATUSES: OrderStatus[] = ['confirmée', 'en_preparation', 'en_livraison', 'livrée', 'annulée'];

export default function CommandesScreen() {
  const { state, updateOrderStatus } = useApp();
  const [expanded, setExpanded] = useState<string | null>(null);
  const orders = [...state.orders].reverse();

  const changeStatus = (order: Order) => {
    Alert.alert('Changer le statut', `Commande #${order.id}`, [
      ...STATUSES.map(s => ({
        text: s.charAt(0).toUpperCase() + s.slice(1).replace('_', ' '),
        onPress: () => updateOrderStatus(order.id, s),
      })),
      { text: 'Annuler', style: 'cancel' },
    ]);
  };

  if (orders.length === 0) {
    return (
      <View style={styles.empty}>
        <Ionicons name="bag-outline" size={64} color={Colors.textMuted} />
        <Text style={styles.emptyTitle}>Aucune commande</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Commandes</Text>
        <Text style={styles.count}>{orders.length} commande{orders.length > 1 ? 's' : ''}</Text>
      </View>

      <FlatList
        data={orders}
        keyExtractor={o => o.id}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ItemSeparatorComponent={() => <View style={{ height: 10 }} />}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <TouchableOpacity
              onPress={() => setExpanded(expanded === item.id ? null : item.id)}
              style={styles.cardHeader}
            >
              <View style={{ flex: 1 }}>
                <Text style={styles.cardRef}>#{item.id}</Text>
                <Text style={styles.cardClient}>{item.clientName} • {item.placedAt}</Text>
              </View>
              <StatusBadge status={item.status} />
              <Ionicons
                name={expanded === item.id ? 'chevron-up' : 'chevron-down'}
                size={16} color={Colors.textMuted} style={{ marginLeft: 8 }}
              />
            </TouchableOpacity>

            {expanded === item.id && (
              <View style={styles.cardBody}>
                <View style={styles.divider} />
                {item.items.map(i => (
                  <Text key={i.id} style={styles.itemText}>
                    • {i.product.name} × {i.quantity}
                  </Text>
                ))}
                <View style={styles.cardFooter}>
                  <Text style={styles.totalLabel}>
                    Total: <Text style={styles.totalAmount}>
                      {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(item.total)}
                    </Text>
                  </Text>
                  <TouchableOpacity onPress={() => changeStatus(item)} style={styles.editBtn}>
                    <Ionicons name="create-outline" size={16} color={Colors.gold} />
                    <Text style={styles.editText}>Statut</Text>
                  </TouchableOpacity>
                </View>
              </View>
            )}
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
  list: { paddingHorizontal: 20, paddingTop: 4, paddingBottom: 100 },
  card: {
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, overflow: 'hidden',
  },
  cardHeader: { flexDirection: 'row', alignItems: 'center', padding: 14, gap: 8 },
  cardRef: { color: Colors.white, fontSize: 13, fontWeight: '700' },
  cardClient: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
  cardBody: { paddingHorizontal: 14, paddingBottom: 14 },
  divider: { height: 1, backgroundColor: Colors.divider, marginBottom: 12 },
  itemText: { color: Colors.textSecondary, fontSize: 13, marginBottom: 4 },
  cardFooter: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginTop: 12 },
  totalLabel: { color: Colors.textSecondary, fontSize: 13 },
  totalAmount: { color: Colors.gold, fontWeight: '700' },
  editBtn: { flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: 12, paddingVertical: 6, borderRadius: 8, borderWidth: 1, borderColor: Colors.gold + '66' },
  editText: { color: Colors.gold, fontSize: 13 },
  empty: { flex: 1, backgroundColor: Colors.background, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyTitle: { color: Colors.white, fontSize: 20, fontWeight: '700', marginTop: 20 },
});
