import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors } from '../constants/Colors';
import type { OrderStatus, CustomRequestStatus } from '../types';

export function GoldDivider() {
  return (
    <View style={styles.row}>
      <View style={styles.line} />
      <View style={styles.dot} />
      <View style={styles.line} />
    </View>
  );
}

export function SectionLabel({ text }: { text: string }) {
  return <Text style={styles.sectionLabel}>{text.toUpperCase()}</Text>;
}

type AnyStatus = OrderStatus | CustomRequestStatus;

const STATUS_CONFIG: Record<string, { label: string; color: string }> = {
  confirmée:     { label: 'Confirmée',     color: '#4CAF50' },
  en_preparation:{ label: 'En préparation',color: Colors.gold },
  en_livraison:  { label: 'En livraison',  color: '#29B6F6' },
  livrée:        { label: 'Livrée',        color: '#4CAF50' },
  annulée:       { label: 'Annulée',       color: Colors.error },
  nouvelle:      { label: 'Nouvelle',      color: Colors.error },
  en_cours:      { label: 'En cours',      color: Colors.gold },
  'devis_envoyé':{ label: 'Devis envoyé',  color: '#29B6F6' },
  acceptée:      { label: 'Acceptée',      color: '#4CAF50' },
  refusée:       { label: 'Refusée',       color: Colors.error },
};

export function StatusBadge({ status }: { status: AnyStatus }) {
  const cfg = STATUS_CONFIG[status] ?? { label: status, color: Colors.textMuted };
  return (
    <View style={[styles.badge, { backgroundColor: cfg.color + '26', borderColor: cfg.color + '66' }]}>
      <Text style={[styles.badgeText, { color: cfg.color }]}>{cfg.label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  row: { flexDirection: 'row', alignItems: 'center' },
  line: { flex: 1, height: 0.5, backgroundColor: Colors.divider },
  dot: { width: 6, height: 6, borderRadius: 3, backgroundColor: Colors.gold, marginHorizontal: 10 },
  sectionLabel: { color: Colors.gold, fontSize: 11, letterSpacing: 2.5, fontWeight: '600' },
  badge: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 20, borderWidth: 1 },
  badgeText: { fontSize: 11, fontWeight: '600' },
});
