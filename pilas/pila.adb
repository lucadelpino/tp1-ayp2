with Unchecked_Deallocation;

package body pila is

   procedure free is new unchecked_deallocation(tipoNodo, tipoPila);

   -- Que hace: crea una pila.
   -- Precondiciones:
   -- Postcondiciones: p=P y P esta creada
   procedure crear(p: out tipoPila)is
   begin
      	p := null;
   end crear;

   -- Que hace: agrega un elemento en el tope de la pila
   -- Precondiciones: p = P y i = I
   -- Postcondiciones: p=P1 y P1 es P con el elemento I agregado al tope
   -- Excepciones: pilaLlena
   procedure apilar (p: in out tipoPila; i: in tipoInfo) is
      aux:tipoPila;
      errorenmemoria: exception;
   begin
         aux:=new tipoNodo;
         aux.all.info:=i;
         aux.all.sig:=p;
         p:=aux;
   exception
      when errorenmemoria => raise pilaLlena;
   end apilar;

   -- Que hace: elimina un elemento del tope de la pila
   -- Precondiciones: p = P
   -- Postcondiciones: p=P1 y P1 es P sin el elemento del tope
   -- Excepciones: pilaVacia
   procedure desapilar (p: in out tipoPila) is
      procedure free is new unchecked_deallocation (tipoNodo, tipoPila);
      aux:tipoPila;
      errorenmemoria: exception;
      begin
         if (p/=null) then
            aux:=p;
            p:=p.all.sig;
            free(aux);
         end if;
      exception
         when errorenmemoria => raise pilaVacia;
   end desapilar;

   -- Que hace: obtiene el elemento del tope de la pila
   -- Precondiciones: p = P
   -- Postcondiciones: i=I e I es elemento del tope de P
   -- Excepciones: pilaVacia
   procedure tope (p: in tipoPila; i: out tipoInfo) is
   begin
      if (p /= null) then
		i := p.all.info;
      else
         raise pilaVacia;
      end if;
   end tope;

   -- Que hace: vacia la pila
   -- Precondiciones: p = P
   -- Postcondiciones: p = P1 y P1 esta vacia
   procedure vaciar (p: in out tipoPila)is
      aux:tipoPila := p;
   begin
      while (aux/= null) loop
         p:=p.sig;
         free(aux);
         aux:=p;
      end loop;
   end vaciar;

   -- Que hace: Determina si la pila esta vacia
   -- Precondiciones: p = P
   -- Postcondiciones: esVacia = Verdadero si la P esta vacia, sino Falso.
   function esVacia (p: in tipoPila) return boolean is
   begin
      	return (p=null);
   end esVacia;

end pila;
