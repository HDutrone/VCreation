import React from 'react';
import {
  View, Text, ScrollView, StyleSheet, TouchableOpacity,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { GoldDivider, StatusBadge } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';

export default function DashboardScreen() {
  const { state } = useApp();
  const orders = state.orders;
  const requests = state.customRequests;
  const products = state.products;

  const revenue = orders.reduce((s, o) => s + o.total, 0);
  const revenueFormatted = new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(revenue);
  const newRequests = requests.filter(r => r.status === 'nouvelle').length;

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
      <View style={styles.header}>
        <View>
          <Text style={styles.label}>TABLEAU DE BORD</Text>
          <Text style={styles.title}>V Créations</Text>
        </View>
        <View style={styles.adminBadge}>
          <Text style={styles.adminBadgeText}>Admin</Text>
        </View>
      </View>

      <View style={{ marginVertical: 16 }}><GoldDivider /></View>

      {/* KPI cards */}
      <View style={styles.kpiGrid}>
        <KpiCard label="Commandes" value={String(orders.length)} icon="bag-outline" color={Colors.gold} />
        <KpiCard label="Revenus" value={revenueFormatted} icon="trending-up-outline" color="#4CAF50" />
        <KpiCard label="Créations" value={String(products.filter(p => p.isActive).length)} icon="shirt-outline" color={Colors.gold} />
        <KpiCard label="Sur-mesure" value={String(newRequests)} icon="cut-outline" color="#F06292" badge={newRequests > 0} />
      </View>

      <View style={{ height: 28 }} />
      <Text style={styles.sectionTitle}>Dernières commandes</Text>
      <View style={{ height: 12 }} />
      {orders.length === 0 ? (
        <Text style={styles.empty}>Aucune commande pour l'instant.</Text>
      ) : (
        orders.slice(0, 5).map(order => (
          <View key={order.id} style={styles.orderRow}>
            <View style={{ flex: 1 }}>
              <Text style={styles.orderRef}>#{order.id}</Text>
              <Text style={styles.orderClient}>{order.clientName}</Text>
            </View>
            <View style={styles.orderRight}>
              <Text style={styles.orderAmount}>
                {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(order.total)}
              </Text>
              <StatusBadge status={order.status} />
            </View>
          </View>
        ))
      )}

      <View style={{ height: 28 }} />
      <Text style={styles.sectionTitle}>Top créations</Text>
      <View style={{ height: 12 }} />
      {products.slice(0, 3).map((p, i) => (
        <View key={p.id} style={styles.topRow}>
          <Text style={styles.topRank}>{i + 1}</Text>
          <View style={{ flex: 1 }}>
            <Text style={styles.topName}>{p.name}</Text>
            <Text style={styles.topViews}>{p.viewCount} vues</Text>
          </View>
          <Ionicons name="eye-outline" size={14} color={Colors.textMuted} />
        </View>
      ))}
      <View style={{ height: 80 }} />
    </ScrollView>
  );
}

function KpiCard({ label, value, icon, color, badge }: { label: string; value: string; icon: any; color: string; badge?: boolean }) {
  return (
    <View style={styles.kpiCard}>
      <View style={styles.kpiTop}>
        <Ionicons name={icon} size={20} color={color} />
        {badge && <View style={styles.kpiBadge}><Text style={styles.kpiBadgeText}>New</Text></View>}
      </View>
      <Text style={styles.kpiValue}>{value}</Text>
      <Text style={styles.kpiLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  content: { padding: 20, paddingTop: 52 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' },
  label: { color: Colors.textMuted, fontSize: 11, letterSpacing: 3 },
  title: { color: Colors.white, fontSize: 28, fontWeight: '700', marginTop: 4 },
  adminBadge: {
    paddingHorizontal: 12, paddingVertical: 6, borderRadius: 20,
    borderWidth: 1, borderColor: Colors.gold + '66', backgroundColor: Colors.goldFaint,
  },
  adminBadgeText: { color: Colors.gold, fontSize: 12 },
  kpiGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12 },
  kpiCard: {
    width: '47.5%', backgroundColor: Colors.surface,
    borderRadius: 14, borderWidth: 1, borderColor: Colors.cardBorder, padding: 16,
  },
  kpiTop: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 10 },
  kpiBadge: { backgroundColor: Colors.error, borderRadius: 8, paddingHorizontal: 6, paddingVertical: 2 },
  kpiBadgeText: { color: Colors.white, fontSize: 9, fontWeight: '700' },
  kpiValue: { color: Colors.white, fontSize: 20, fontWeight: '700', marginBottom: 4 },
  kpiLabel: { color: Colors.textMuted, fontSize: 12 },
  sectionTitle: { color: Colors.white, fontSize: 16, fontWeight: '700' },
  empty: { color: Colors.textMuted, fontSize: 13, marginTop: 8 },
  orderRow: {
    flexDirection: 'row', alignItems: 'center',
    backgroundColor: Colors.surface, borderRadius: 12,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 14, marginBottom: 8,
  },
  orderRef: { color: Colors.gold, fontSize: 13, fontWeight: '700' },
  orderClient: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
  orderRight: { alignItems: 'flex-end', gap: 6 },
  orderAmount: { color: Colors.white, fontSize: 13, fontWeight: '600' },
  topRow: {
    flexDirection: 'row', alignItems: 'center', gap: 12,
    paddingVertical: 12,
    borderBottomWidth: 1, borderBottomColor: Colors.divider,
  },
  topRank: { color: Colors.gold, fontSize: 18, fontWeight: '700', width: 24 },
  topName: { color: Colors.white, fontSize: 14 },
  topViews: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
});
