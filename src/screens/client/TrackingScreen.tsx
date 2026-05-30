import React from 'react';
import { View, Text, ScrollView, TouchableOpacity, StyleSheet } from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { GoldDivider, StatusBadge } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';

type Props = NativeStackScreenProps<RootStackParamList, 'Tracking'>;

const STEPS = [
  { key: 'confirmée', label: 'Commande confirmée', icon: 'checkmark-circle-outline' as const },
  { key: 'en_preparation', label: 'En préparation', icon: 'construct-outline' as const },
  { key: 'en_livraison', label: 'En livraison', icon: 'bicycle-outline' as const },
  { key: 'livrée', label: 'Livrée', icon: 'home-outline' as const },
];

const STATUS_ORDER = ['confirmée', 'en_preparation', 'en_livraison', 'livrée'];

export default function TrackingScreen({ route, navigation }: Props) {
  const { orderId } = route.params;
  const { state } = useApp();
  const order = state.orders.find(o => o.id === orderId);

  if (!order) {
    return (
      <View style={styles.center}>
        <Text style={styles.notFound}>Commande introuvable</Text>
      </View>
    );
  }

  const currentStep = STATUS_ORDER.indexOf(order.status);

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <TouchableOpacity onPress={() => navigation.goBack()} style={styles.back}>
        <Ionicons name="arrow-back" size={22} color={Colors.white} />
      </TouchableOpacity>

      <Text style={styles.title}>Suivi commande</Text>
      <Text style={styles.orderId}>#{order.id}</Text>
      <View style={{ marginVertical: 20 }}><GoldDivider /></View>

      <View style={styles.infoCard}>
        <Row label="Client" value={order.clientName} />
        <Row label="Paiement" value={order.paymentMethod ?? 'N/A'} />
        <Row label="Date" value={order.placedAt} />
        <View style={styles.rowStatus}>
          <Text style={styles.rowLabel}>Statut</Text>
          <StatusBadge status={order.status} />
        </View>
      </View>

      <View style={{ height: 28 }} />
      <Text style={styles.sectionTitle}>Progression</Text>
      <View style={{ height: 16 }} />

      {STEPS.map((step, index) => {
        const done = index <= currentStep;
        const active = index === currentStep;
        return (
          <View key={step.key} style={styles.stepRow}>
            <View style={styles.stepLeft}>
              <View style={[styles.stepCircle, done && styles.stepCircleDone, active && styles.stepCircleActive]}>
                <Ionicons
                  name={step.icon}
                  size={18}
                  color={done ? Colors.gold : Colors.textMuted}
                />
              </View>
              {index < STEPS.length - 1 && (
                <View style={[styles.stepLine, done && index < currentStep && styles.stepLineDone]} />
              )}
            </View>
            <Text style={[styles.stepLabel, done && styles.stepLabelDone]}>{step.label}</Text>
          </View>
        );
      })}

      <View style={{ height: 40 }} />
      <View style={styles.itemsCard}>
        <Text style={styles.itemsTitle}>Articles ({order.items.length})</Text>
        {order.items.map(i => (
          <View key={i.id} style={styles.itemRow}>
            <Text style={styles.itemName} numberOfLines={1}>{i.product.name} × {i.quantity}</Text>
            <Text style={styles.itemPrice}>
              {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(i.product.price * i.quantity)}
            </Text>
          </View>
        ))}
        <View style={styles.totalRow}>
          <Text style={styles.totalLabel}>Total</Text>
          <Text style={styles.totalAmount}>
            {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(order.total)}
          </Text>
        </View>
      </View>
      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.row}>
      <Text style={styles.rowLabel}>{label}</Text>
      <Text style={styles.rowValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  content: { padding: 20, paddingTop: 52 },
  center: { flex: 1, backgroundColor: Colors.background, alignItems: 'center', justifyContent: 'center' },
  notFound: { color: Colors.textSecondary, fontSize: 16 },
  back: { marginBottom: 16, width: 36 },
  title: { color: Colors.white, fontSize: 28, fontWeight: '700' },
  orderId: { color: Colors.gold, fontSize: 13, marginTop: 4 },
  infoCard: {
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, padding: 16,
  },
  row: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 10 },
  rowStatus: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  rowLabel: { color: Colors.textMuted, fontSize: 13 },
  rowValue: { color: Colors.white, fontSize: 13, fontWeight: '600' },
  sectionTitle: { color: Colors.white, fontSize: 16, fontWeight: '700' },
  stepRow: { flexDirection: 'row', alignItems: 'flex-start', marginBottom: 0 },
  stepLeft: { alignItems: 'center', width: 40 },
  stepCircle: {
    width: 36, height: 36, borderRadius: 18,
    backgroundColor: Colors.surface, borderWidth: 1, borderColor: Colors.cardBorder,
    alignItems: 'center', justifyContent: 'center',
  },
  stepCircleDone: { borderColor: Colors.gold, backgroundColor: Colors.goldFaint },
  stepCircleActive: { borderWidth: 2 },
  stepLine: { width: 1.5, height: 32, backgroundColor: Colors.divider, marginTop: 2 },
  stepLineDone: { backgroundColor: Colors.gold },
  stepLabel: { color: Colors.textMuted, fontSize: 14, paddingTop: 8, paddingLeft: 12, flex: 1 },
  stepLabelDone: { color: Colors.white },
  itemsCard: {
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, padding: 16,
  },
  itemsTitle: { color: Colors.white, fontSize: 14, fontWeight: '700', marginBottom: 12 },
  itemRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 },
  itemName: { color: Colors.textSecondary, fontSize: 13, flex: 1, marginRight: 8 },
  itemPrice: { color: Colors.white, fontSize: 13, fontWeight: '600' },
  totalRow: {
    flexDirection: 'row', justifyContent: 'space-between',
    paddingTop: 12, marginTop: 4, borderTopWidth: 1, borderTopColor: Colors.divider,
  },
  totalLabel: { color: Colors.white, fontSize: 14, fontWeight: '700' },
  totalAmount: { color: Colors.gold, fontSize: 16, fontWeight: '700' },
});
