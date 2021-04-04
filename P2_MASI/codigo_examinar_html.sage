# -*- coding: utf-8 -*-

r"""
AUTORES:
- Victor Álverez, Maribel Hartillo, Rafael Robles -- versión inicial, 2012.
- Emmanuel Briand, Rafael Robles -- revisión y adaptación a Sage 9, 2020.
"""

latex.matrix_delimiters("[", "]")

import pickle

#---------------------------------------------------------------------------------------------   

def show_html(s):
    r"""
    Sustituye ``pretty_print(html(s))``, 
    corrigiendo problemas que surgen con signos diacríticos 
    en Sage 8.versiones recientes de Sage (por lo menos 8.2 y siguientes)

    INPUT: 

    - ``s`` -- string

    EJEMPLO:

        sage: pretty_print(html('¡Holà!')) # sage 8.4, Jupyter
        wqFIb2zDoCE= 

        sage: show_html('¡Holà!')
        ...
    """
    if eval(sage.version.version) >= 8.8:
        pretty_print(html(s)) 
    else:
        try:
            pretty_print(html(s.decode('utf-8').encode('ascii', 'xmlcharrefreplace'))) 
        except:
            pretty_print(html(s.encode('ascii', 'xmlcharrefreplace')))


def matrix_from_copypaste(R, Nrows, Ncols, s):
    r"""
    Transforma la lista de coeficientes copiada y pegada desde el cuestionario, 
    en matriz con símbolos de sustracción correctos.
    
    INPUT:
    - ``R`` -- anillo de base, por ejemplo ``RR``, ``QQ``, ``ZZ``
    - ``Nrows`` -- integer, número de filas 
    - ``Ncols`` -- integer, número de columnas
    - ``s`` -- cadena de caracteres obtenida al copiar y pegar con el ratón 
    los coeficientes de un matriz del cuestionario
    """
    if len(s) > 0 and s[-1] == ",": 
        s = s[:-1]
    L = [ eval(x) for x in s.replace("−","-").split(",")]
    return matrix(R, Ncols, Nrows, L).transpose()


def improved_table_style(s):
    r"""
    Mejora la presentación de las propuestas en los cuestionarios:
    - los textos son alineados a la izquierda
    - las propuestas ocupan todo el ancho del cuestionario, evitando "awkward wrapping""
    """
    ### Eliminación de las lineas entre celdas de las tablas.
    return (s.replace('<td>', '<td style="border:none; text-align:left">')
            .replace('<table>','<table style=" width:100%">'))


def pickle_load(f):
    r"""
    Wrapper for ``pickle.load``.
 
    The function ``pickle.load`` needs different options when ``f`` is
    a string dumped witb python2 or python3. 
    This wrapper replaces `pickle.load(f)` so that it works in both cases.  
    """
    if eval(sage.version.version) < 9:
        res = pickle.load(f)
    else:
        res = pickle.load(f, encoding='utf8') # dumped in python 8
    return res

def pickle_dump(s, f):
    r"""
    Wrapper for ``pickle.dump``.
    
    Call ``pickle.dump`` with option ``protocol=2`` so that the pickles created with 
    Sage9/python3 can be read with Sage8/python2.
    
    REFERENCE:
    
        https://stackoverflow.com/questions/25843698/valueerror-unsupported-pickle-protocol-3-python2-pickle-can-not-load-the-file
    """
    pickle.dump(s, f, protocol=2)
    return None
        

def lectura(fichero_base, nexam, ver_informacion):
    with open(fichero_base, 'rb') as f:
        ref = pickle_load(f)
        ne = pickle_load(f)
        TEXTOS = pickle_load(f)       
        nalumnos = list(TEXTOS.keys())
    return (ref, ne, TEXTOS, nalumnos)

def lector_examenes(fichero_base= input_box('', type = str, 
                                            label='<br>Nombre del fichero base:<br>',width=20), 
                    nexam= input_box(0,  label='Nº de examen:',width=20), 
                    ver_informacion=True, auto_update=False):
    if fichero_base == '':
        print('Introduzca el nombre del fichero que contiene los exámenes.')
        return
    (ref, ne, ENUNCIADOS, nalumnos) = lectura(fichero_base, nexam, ver_informacion)
    if ver_informacion:
        print('REFERENCIA DEL FICHERO:')
        print(ref)
        print("")
        print('Nº de exámenes disponibles: {}'.format(ne))
        print("")
    if nexam == 0:
        show_html('Introduzca su número de alumno.')
        return
    if not(nexam in nalumnos):
        raise ValueError('No existe ningún cuestionario para ese número de alumno.')
    enun = ENUNCIADOS[nexam]
    enun = improved_table_style(enun)
    show_html(enun)
    return