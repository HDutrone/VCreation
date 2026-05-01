import React from 'react';
import {
  View, Text, FlatList, StyleSheet, TouchableOpacity, Linking,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { useApp } from '../../context/AppContext';

const DEMO_CLIENTS = [
  { id: 'u1', name: 'Amina Diallo', email: 'amina@vcreations.cd', phone: '+243810001111', orders: 3, since: 'Jan 2024' },
  { id: 'u2', name: 'Fatoumata Koné', email: 'fatou@example.com', phone: '+243810002222', orders: 1, since: 'Mar 2024' },
  { id: 'u3', name: 'Mariama Bah', email: 'mariama@example.com', phone: '+243810003333', orders: 2, since: 'Fév 2024' },
  { id: 'u4', name: 'Nadia Traoré', email: 'nadia@example.com', phone: '+243810004444', orders: 0, since: 'Avr 2024' },
];

export default function ClientsScreen() {
  const { state } = useApp();
  const totalOrders = state.orders.length;

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Clients</Text>
        <Text style={styles.count}>{DEMO_CLIENTS.length} inscrits</Text>
      </View>

      {/* Summary */}
      <View style={styles.summary}>
        <SummaryCard label="Total clients" value={String(DEMO_CLIENTS.length)} icon="people-outline" />
        <SummaryCard label="Commandes" value={String(totalOrders)} icon="bag-outline" />
        <SummaryCard label="Actifs" value="3" icon="radio-button-on-outline" />
      </View>

      <FlatList
        data={DEMO_CLIENTS}
        keyExtractor={c => c.id}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ItemSeparatorComponent={() => <View style={{ height: 10 }} />}
        renderItem={({ item }) => (
          <View style={styles.card}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{item.name[0]}</Text>
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.clientName}>{item.name}</Text>
              <Text style={styles.clientEmail}>{item.email}</Text>
              <Text style={styles.clientSince}>Depuis {item.since} • {item.orders} commande{item.orders > 1 ? 's' : ''}</Text>
            </View>
            <View style={styles.actions}>
              <TouchableOpacity
                style={styles.actionBtn}
                onPress={() => Linking.openURL(`mailto:${item.email}`)}
              >
                <Ionicons name="mail-outline" size={18} color={Colors.gold} />
              </TouchableOpacity>
              <TouchableOpacity
                style={styles.actionBtn}
                onPress={() => Linking.openURL(`https://wa.me/${item.phone.replace('+', '')}`)}
              >
                <Ionicons name="logo-whatsapp" size={18} color="#25D366" />
              </TouchableOpacity>
            </View>
          </View>
        )}
      />
    </View>
  );
}

function SummaryCard({ label, value, icon }: { label: string; value: string; icon: any }) {
  return (
    <View style={styles.summaryCard}>
      <Ionicons name={icon} size={18} color={Colors.gold} />
      <Text style={styles.summaryValue}>{value}</Text>
      <Text style={styles.summaryLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: { paddingHorizontal: 20, paddingTop: 52, paddingBottom: 12 },
  title: { color: Colors.white, fontSize: 32, fontWeight: '700' },
  count: { color: Colors.textMuted, fontSize: 11, letterSpacing: 2, marginTop: 2 },
  summary: { flexDirection: 'row', paddingHorizontal: 20, gap: 10, marginBottom: 16 },
  summaryCard: {
    flex: 1, backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 12, alignItems: 'center', gap: 4,
  },
  summaryValue: { color: Colors.white, fontSize: 18, fontWeight: '700' },
  summaryLabel: { color: Colors.textMuted, fontSize: 10 },
  list: { paddingHorizontal: 20, paddingBottom: 100 },
  card: {
    flexDirection: 'row', alignItems: 'center', gap: 12,
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, padding: 14,
  },
  avatar: {
    width: 48, height: 48, borderRadius: 24,
    backgroundColor: Colors.goldFaint, borderWidth: 1.5, borderColor: Colors.gold,
    alignItems: 'center', justifyContent: 'center',
  },
  avatarText: { color: Colors.gold, fontSize: 20, fontWeight: '700' },
  clientName: { color: Colors.white, fontSize: 14, fontWeight: '700' },
  clientEmail: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
  clientSince: { color: Colors.textMuted, fontSize: 11, marginTop: 2 },
  actions: { gap: 8 },
  actionBtn: {
    width: 36, height: 36, borderRadius: 10,
    backgroundColor: Colors.card, borderWidth: 1, borderColor: Colors.cardBorder,
    alignItems: 'center', justifyContent: 'center',
  },
});
