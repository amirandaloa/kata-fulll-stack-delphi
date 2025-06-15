
/*
 
    * Kata Fullstack Delphi [Data Snap VCL Forms]
    * Opción HTML-JS-CSS ya que no he trabajado con Angular anque conozco typescript haciendo apps móviles con IONIC basado en [Angular]
    * All Rights Reserved : No reserved esto es libre es una prueba en un servidor local
    * Backend DELPHI 10 seattle 
    * Base de datos SQL Server 19.2 Express edition
    * Servidor web  hecho con Python 3.12
    * Autor: Alejandro Miranda Loaiza
 
*/

document.addEventListener('DOMContentLoaded', () => {

    const BASE_URL = 'http://localhost:50334/api';

    // Función para obtener y mostrar caficultores
    async function recuperarCaficultores() {
        try {
            const response = await fetch(`${BASE_URL}/GetCaficultores`);
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

            const serverResponse = await response.json();

            const jsonString = serverResponse;

            const caficultoresData = JSON.parse(jsonString);

            const table = document.getElementById('caficultores-table');
            let tableBody = table.getElementsByTagName('tbody')[0];
            tableBody.innerHTML = '';

            if (Array.isArray(caficultoresData) && caficultoresData.length > 0) {
                caficultoresData.forEach(caficultor => {
                    const row = tableBody.insertRow();
                    row.insertCell().textContent = caficultor.id;
                    row.insertCell().textContent = caficultor.nombre;
                    row.insertCell().textContent = caficultor.identificacion;
                    row.insertCell().textContent = caficultor.ciudad;
                    row.insertCell().textContent = caficultor.tipo_producto;
                });
            } else {
                const row = tableBody.insertRow();
                const cell = row.insertCell(0);
                cell.colSpan = 5;
                cell.textContent = 'No hay caficultores registrados.';
                cell.style.textAlign = 'center';
                cell.style.padding = '20px';
            }

        } catch (error) {
            console.error('Error al obtener caficultores:', error);
        }
    }


    // Función para obtener y mostrar abonos
    async function recuperarAbonos() {
        try {
            const response = await fetch(`${BASE_URL}/GetAbonosMonedero`);

            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

            const data = await response.json();

            const jsonString = data;
            const abonosData = JSON.parse(jsonString);

            const table = document.getElementById('abonos-table');
            let tableBody = table.getElementsByTagName('tbody')[0];
            tableBody.innerHTML = '';

            if (Array.isArray(abonosData) && abonosData.length > 0) {
                abonosData.forEach(abono => {
                    const row = tableBody.insertRow();
                    row.insertCell().textContent = abono.id;
                    row.insertCell().textContent = abono.id_caficultor;
                    row.insertCell().textContent = abono.valor.toFixed(2);
                    const partes = abono.fecha.split(/[\/ :]/);
                    const fechaISO = `${partes[2]}-${partes[1].padStart(2, '0')}-${partes[0].padStart(2, '0')}T${partes[3]}:${partes[4]}:${partes[5]}`;

                    const fechaObj = new Date(fechaISO);

                    row.insertCell().textContent = fechaObj.toLocaleDateString('es-CO', {
                        day: '2-digit',
                        month: '2-digit',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit'
                    });
                });
            } else {
                const row = tableBody.insertRow();
                const cell = row.insertCell(0);
                cell.colSpan = 5;
                cell.textContent = 'No hay abonos registrados.';
                cell.style.textAlign = 'center';
                cell.style.padding = '20px';
            }

        } catch (error) {
            console.error('Error al obtener abonos:', error);
        }
    }

    // Función para registrar un nuevo caficultor
    const formRegistrarCaficultor = document.getElementById('form-registrar-caficultor');
    if (formRegistrarCaficultor) {
        formRegistrarCaficultor.addEventListener('submit', async (event) => {


            event.preventDefault();

            const nombre = document.getElementById('nombre-caficultor').value;
            const identificacion = document.getElementById('identificacion-caficultor').value;
            const ciudad = document.getElementById('ciudad-caficultor').value;
            const tipoProducto = document.getElementById('tipo-producto-caficultor').value;



            try {

                const response = await fetch(`${BASE_URL}/RegistrarCaficultor`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ Nombre: nombre, Identificacion: identificacion, Ciudad: ciudad, TipoProducto: tipoProducto }),
                });

                const responseText = await response.text();
                if (responseText.toUpperCase().includes("ERROR")) {
                    alert('Error al registrar caficultor');
                    return;
                }

                alert('Caficultor registrado exitosamente!');

                formRegistrarCaficultor.reset();

                recuperarCaficultores();
            } catch (error) {
                console.error('Error al registrar caficultor:', error);
                alert(`Error al registrar caficultor: ${error.message}`);
            }
        });
    }

    // Función para registrar un abono
    const formRegistrarAbono = document.getElementById('form-registrar-abono');
    if (formRegistrarAbono) {

        formRegistrarAbono.addEventListener('submit', async (event) => {
            event.preventDefault();

            const idCaficultor = parseInt(document.getElementById('id-caficultor-abono').value);
            const monto = parseFloat(document.getElementById('monto-abono').value);


            if (monto <= 0) {
                alert('No se permiten abonos negativos ni cero.');
                return;
            }

            try {

                const response = await fetch(`${BASE_URL}/RegistrarAbono`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ IdCaficultor: idCaficultor, Valor: monto }),
                });

                const responseText = await response.text();
                if (responseText.toUpperCase().includes("ERROR")) {
                    alert('Error al registrar abono');
                    return;
                }

                alert('Abono registrado exitosamente!');
                formRegistrarAbono.reset();
                recuperarAbonos();
            } catch (error) {
                console.error('Error al registrar abono:', error);
                alert(`Error al registrar abono: ${error.message}`);
            }
        });
    }

    const formConsultarSaldo = document.getElementById('form-consultar-saldo');
    const saldoMonederoSpan = document.getElementById('saldo-monedero');

    if (formConsultarSaldo && saldoMonederoSpan) {
        formConsultarSaldo.addEventListener('submit', async (event) => {
            event.preventDefault();

            const idCaficultor = parseInt(document.getElementById('id-caficultor-saldo').value);

            try {
                const response = await fetch(`${BASE_URL}/ConsultarSaldoMonedero?IdCaficultor=${idCaficultor}`);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const saldoTextoRaw = await response.text();
                const saldoTexto = saldoTextoRaw.replace(/"/g, '');
                const saldo = parseFloat(saldoTexto);

                saldoMonederoSpan.textContent = !isNaN(saldo)
                    ? `$${saldo.toFixed(2)}`
                    : 'No encontrado';
            } catch (error) {
                console.error('Error al consultar saldo:', error);
                saldoMonederoSpan.textContent = 'Error al consultar';
                alert('Error al consultar el saldo. Consulta la consola para más detalles.');
            }
        });
    }



    const botonCargarCaficultores = document.getElementById("btn-cargar-caficultores");

    botonCargarCaficultores.addEventListener('click', async (event) => {
        event.preventDefault();
        recuperarCaficultores();
    });

    const botonCargarAbonos = document.getElementById("btn-cargar-abonos");

    botonCargarAbonos.addEventListener('click', async (event) => {
        event.preventDefault();
        recuperarAbonos();
    });



    document.querySelectorAll('nav ul li a').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
});