import 'package:flutter/material.dart';
import 'package:app_taxi/models/taxi.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/info_card.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:app_taxi/widgets/taxi_profile_header.dart';

class DetailTaxiScreen extends StatefulWidget {
  final Taxi taxi;

  const DetailTaxiScreen({
    super.key,
    required this.taxi,
  });

  @override
  State<DetailTaxiScreen> createState() =>
      _DetailTaxiScreenState();
}

class _DetailTaxiScreenState
    extends State<DetailTaxiScreen> {
  late Taxi taxi;

  bool isUpdating = false;

  List<dynamic> _conductores = [];

  @override
  void initState() {
    super.initState();

    taxi = widget.taxi;

    _cargarConductores();
  }

  void _cargarConductores() async {
    final result =
        await ApiService.getConductores();

    if (!mounted) return;

    setState(() {
      _conductores = result;
    });
  }

  void _showEditDialog() {
    final marcaController =
        TextEditingController(
          text: taxi.marca,
        );

    final modeloController =
        TextEditingController(
          text: taxi.modelo,
        );

    final cedulaController =
        TextEditingController(
          text:
              taxi.conductor?.cedula
                  .toString() ??
              '',
        );

    List<dynamic> filtrados = [];

    dynamic seleccionado =
        taxi.conductor;

    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (dialogContext, setDS) {
                void filtrar() {
                  final query =
                      cedulaController.text
                          .trim();

                  setDS(() {
                    if (query.isEmpty) {
                      filtrados = [];
                    } else {
                      filtrados =
                          _conductores
                              .where(
                                (c) => c
                                    .cedula
                                    .toString()
                                    .contains(
                                      query,
                                    ),
                              )
                              .toList();
                    }
                  });
                }

                void seleccionar(
                  dynamic c,
                ) {
                  setDS(() {
                    seleccionado = c;

                    cedulaController
                        .text = c.cedula
                        .toString();

                    filtrados = [];
                  });
                }

                return AlertDialog(
                  title: const Text(
                    "Editar Taxi",
                  ),

                  content:
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [
                            // MARCA
                            TextField(
                              controller:
                                  marcaController,

                              decoration:
                                  const InputDecoration(
                                    labelText:
                                        "Marca",
                                  ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // MODELO
                            TextField(
                              controller:
                                  modeloController,

                              decoration:
                                  const InputDecoration(
                                    labelText:
                                        "Modelo",
                                  ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // CONDUCTOR
                            TextField(
                              controller:
                                  cedulaController,

                              keyboardType:
                                  TextInputType
                                      .number,

                              decoration:
                                  const InputDecoration(
                                    labelText:
                                        "Cédula del Conductor",
                                  ),

                              onChanged:
                                  (_) =>
                                      filtrar(),
                            ),

                            // LISTA FILTRADA
                            if (filtrados
                                .isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsets.only(
                                      top: 4,
                                    ),

                                decoration:
                                    BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Colors
                                                .grey
                                                .shade300,
                                      ),

                                      borderRadius:
                                          BorderRadius.circular(
                                            8,
                                          ),
                                    ),

                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,

                                  children:
                                      filtrados.map<
                                        Widget
                                      >((c) {
                                        return ListTile(
                                          leading:
                                              const Icon(
                                                Icons
                                                    .person,
                                                color:
                                                    Colors
                                                        .blue,
                                              ),

                                          title: Text(
                                            c.nombre,
                                          ),

                                          subtitle: Text(
                                            "Cédula: ${c.cedula}",
                                          ),

                                          onTap:
                                              () =>
                                                  seleccionar(
                                                    c,
                                                  ),
                                        );
                                      }).toList(),
                                ),
                              ),

                            // SELECCIONADO
                            if (seleccionado !=
                                null)
                              Container(
                                margin:
                                    const EdgeInsets.only(
                                      top: 8,
                                    ),

                                padding:
                                    const EdgeInsets.all(
                                      12,
                                    ),

                                decoration:
                                    BoxDecoration(
                                      color:
                                          Colors
                                              .green
                                              .shade50,

                                      borderRadius:
                                          BorderRadius.circular(
                                            8,
                                          ),

                                      border: Border.all(
                                        color:
                                            Colors
                                                .green
                                                .shade300,
                                      ),
                                    ),

                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .check_circle,
                                      color:
                                          Colors
                                              .green,
                                    ),

                                    const SizedBox(
                                      width: 8,
                                    ),

                                    Expanded(
                                      child: Text(
                                        seleccionado
                                            .nombre,

                                        style:
                                            const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,

                                              color:
                                                  Colors
                                                      .green,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                  actions: [
                    // CANCELAR
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                        );
                      },

                      child: const Text(
                        "Cancelar",
                      ),
                    ),

                    // GUARDAR
                    ElevatedButton(
                      onPressed: () async {
                        final nuevaMarca =
                            marcaController.text
                                .trim();

                        final nuevoModelo =
                            modeloController.text
                                .trim();

                        if (nuevaMarca
                                .isEmpty ||
                            nuevoModelo
                                .isEmpty) {
                          return;
                        }

                        if (taxi.id ==
                            null) {
                          return;
                        }

                        if (seleccionado ==
                            null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Selecciona un conductor válido",
                              ),
                            ),
                          );

                          return;
                        }

                        setState(() {
                          isUpdating =
                              true;
                        });

                        final result =
                            await ApiService.updateTaxi(
                              id:
                                  taxi.id!,
                              placa:
                                  taxi
                                      .placa,
                              marca:
                                  nuevaMarca,
                              modelo:
                                  nuevoModelo,
                              conductorId:
                                  seleccionado
                                      .id,
                            );

                        if (!mounted) {
                          return;
                        }

                        setState(() {
                          isUpdating =
                              false;

                          if (result
                              .success) {
                            taxi = Taxi(
                              id:
                                  taxi.id,

                              placa:
                                  taxi
                                      .placa,

                              marca:
                                  nuevaMarca,

                              modelo:
                                  nuevoModelo,

                              conductor:
                                  seleccionado,
                            );
                          }
                        });

                        Navigator.pop(
                          dialogContext,
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              result.message,
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        "Guardar",
                      ),
                    ),
                  ],
                );
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF2F3F5),

      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title:
                  'Detalle del Taxi',

              onBack:
                  () => Navigator.pop(
                    context,
                  ),
            ),

            const SizedBox(
              height: 20,
            ),

            TaxiProfileHeader(
              taxi: taxi,
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

              child: Column(
                children: [
                  InfoCard(
                    icon:
                        Icons
                            .confirmation_number,

                    title: "Placa",

                    value: taxi.placa,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  InfoCard(
                    icon:
                        Icons
                            .branding_watermark,

                    title: "Marca",

                    value: taxi.marca,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  InfoCard(
                    icon:
                        Icons
                            .calendar_month,

                    title: "Modelo",

                    value: taxi.modelo,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  InfoCard(
                    icon: Icons.person,

                    title:
                        "Conductor",

                    value:
                        taxi.conductor
                            ?.nombre ??
                        "No asignado",
                  ),
                ],
              ),
            ),

            if (isUpdating)
              const Padding(
                padding:
                    EdgeInsets.all(8),

                child:
                    CircularProgressIndicator(),
              ),

            const Spacer(),

            Padding(
              padding:
                  const EdgeInsets.all(
                    16,
                  ),

              child: Column(
                children: [
                  SizedBox(
                    width:
                        double.infinity,

                    child:
                        OutlinedButton.icon(
                          onPressed:
                              _showEditDialog,

                          icon:
                              const Icon(
                                Icons.edit,
                              ),

                          label:
                              const Text(
                                "Modificar Datos",
                              ),
                        ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    width:
                        double.infinity,

                    child:
                        ElevatedButton(
                          onPressed:
                              () =>
                                  Navigator.pop(
                                    context,
                                  ),

                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                      0xFF2E4E73,
                                    ),

                                foregroundColor:
                                    Colors
                                        .white,

                                padding:
                                    const EdgeInsets.symmetric(
                                      vertical:
                                          14,
                                    ),
                              ),

                          child:
                              const Text(
                                "Volver",
                              ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}